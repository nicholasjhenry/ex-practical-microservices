mono.build:
	docker build --rm --build-arg MIX_ENV=prod -t video-tutorials-local -f Dockerfile .

mono.run:
	docker run -i --name video-tutorials -t --rm -p 4000:4000 \
		-e DATABASE_URL=postgres://postgres:postgres@host.docker.internal/video_tutorials_dev \
		-e DATABASE_SSL=0 \
		-e HOST=localhost \
		-e SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		video-tutorials-local /app/bin/video_tutorials start

dist.build:
	docker build --rm --build-arg MIX_ENV=prod -t video-tutorials-frontend -f Dockerfile.frontend .
	docker build --rm --build-arg MIX_ENV=prod -t video-tutorials-backend -f Dockerfile.backend .

dist.run:
	docker run -i --name video-tutorials-frontend -t --rm -p 4000:4000 \
		-e DATABASE_URL=postgres://postgres:postgres@host.docker.internal/video_tutorials_dev \
		-e DATABASE_SSL=0 \
		-e HOST=localhost \
		-e SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		video-tutorials-frontend /app/bin/video_tutorials start
	docker run -i --name video-tutorials-backend -t --rm \
		-e DATABASE_URL=postgres://postgres:postgres@host.docker.internal/video_tutorials_dev \
		-e DATABASE_SSL=0 \
		-e HOST=localhost \
		-e SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		video-tutorials-backend /app/bin/video_tutorials start