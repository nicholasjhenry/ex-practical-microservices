build:
	docker build --rm --build-arg MIX_ENV=prod -t video-tutorials-local -f Dockerfile .

run:
	docker run -i --name video-tutorials -t --rm -p 4000:4000 \
		-e DATABASE_URL=postgres://postgres:postgres@host.docker.internal/video_tutorials_dev \
		-e POOL_SIZE=10 \
		-e HOST=localhost \
		-e SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		video-tutorials-local /app/bin/video_tutorials start