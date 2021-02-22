## BUILDER

# - bsd-compat-headers required for bcrypt

FROM elixir:1.11.2-alpine as builder
RUN apk add --no-cache \
    gcc \
    git \
    make \
    musl-dev \
    bsd-compat-headers
RUN mix local.rebar --force && \
    mix local.hex --force

## DEPS

FROM builder as deps

ARG MIX_ENV=staging
ENV MIX_ENV ${MIX_ENV}
RUN echo " ===> [debug] MIX_ENV=$MIX_ENV"

# Provide the release tag
ARG RELEASE_TAG
ENV RELEASE_TAG ${RELEASE_TAG}
RUN echo " ===> [debug] RELEASE_TAG=$RELEASE_TAG"

WORKDIR /app

COPY mix.* /app/
COPY apps/creators_portal/mix.* /app/apps/creators_portal/
COPY apps/creators_portal_web/mix.* /app/apps/creators_portal_web/
COPY apps/video_tutorials/mix.* /app/apps/video_tutorials/
COPY apps/video_tutorials_proxy/mix.* /app/apps/video_tutorials_proxy/
COPY apps/video_tutorials_web/mix.* /app/apps/video_tutorials_web/
COPY packages packages

RUN mix do deps.get --only $MIX_ENV, deps.compile

## FRONT-END - WEB

FROM node:14.4.0-alpine3.12 as frontend-creators-portal
WORKDIR /app
COPY apps/shared_assets /shared_assets
COPY apps/creators_portal_web/assets/package*.json /app/
COPY --from=deps /app/deps/phoenix /deps/phoenix
COPY --from=deps /app/deps/phoenix_html /deps/phoenix_html
COPY --from=deps /app/deps/phoenix_live_view /deps/phoenix_live_view
RUN npm ci
COPY apps/creators_portal_web/assets /app
RUN npm run deploy

## FRONT-END - BACKOFFICE

FROM node:14.4.0-alpine3.12 as frontend-video-tutorials
WORKDIR /app
COPY apps/shared_assets /shared_assets
COPY apps/video_tutorials_web/assets/package*.json /app/
COPY --from=deps /app/deps/phoenix /deps/phoenix
COPY --from=deps /app/deps/phoenix_html /deps/phoenix_html
COPY --from=deps /app/deps/phoenix_live_view /deps/phoenix_live_view
RUN npm ci
COPY apps/video_tutorials_web/assets /app
RUN npm run deploy

## RELEASER

FROM deps as releaser
WORKDIR /app
COPY config config
COPY apps apps
COPY --from=frontend-creators-portal /priv/static apps/creators_portal_web/priv/static
COPY --from=frontend-video-tutorials /priv/static apps/video_tutorials_web/priv/static

ENV MIX_ENV ${MIX_ENV}
RUN MIX_ENV=$MIX_ENV mix do phx.digest, release video_tutorials_$MIX_ENV

## RUNNER

FROM alpine:3.11 as runner
# bash and openssl for Phoenix
# and curl to perform deployments on Heroku
RUN apk add --no-cache -U bash libssl1.1 openssl openssh curl python imagemagick postgresql-client

WORKDIR /app

# Provide a default for the MIX_ENV, see heroku.yml for more information
ARG MIX_ENV=staging
ENV PORT=4000 \
    SHELL=/bin/bash

COPY --from=releaser /app/_build/$MIX_ENV/rel/video_tutorials_$MIX_ENV .
RUN ln -s /app/bin/video_tutorials_$MIX_ENV /app/bin/video_tutorials

# Copy shell scripts
COPY bin/ /app/bin

RUN \
  adduser -s /bin/sh -u 1001 -G root -h /app -S -D default && \
  chown -R 1001:0 /app
USER default

# EXPOSE is not used by Heroku, it uses the PORT env var and expose the same value
EXPOSE 4000
CMD ["/app/bin/video_tutorials", "start"]