mono.start:
	DATABASE_URL=postgres://postgres:postgres@localhost/video_tutorials_dev \
		DATABASE_SSL=0 \
		HOST=localhost \
		SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		_build/prod/rel/video_tutorials_prod/bin/video_tutorials_prod start

mono.release:
	MIX_ENV=prod mix do phx.digest, release

dist.start:
	DATABASE_URL=postgres://postgres:postgres@localhost/video_tutorials_dev \
		DATABASE_SSL=0 \
		HOST=localhost \
		SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		_build/prod/rel/video_tutorials_frontend/bin/video_tutorials_frontend start
	DATABASE_URL=postgres://postgres:postgres@localhost/video_tutorials_dev \
		DATABASE_SSL=0 \
		HOST=unknown \
		SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		_build/prod/rel/video_tutorials_backend/bin/video_tutorials_backend start

dist.release:
	MIX_ENV=prod mix do phx.digest, release video_tutorials_frontend
	MIX_ENV=prod mix do release video_tutorials_backend