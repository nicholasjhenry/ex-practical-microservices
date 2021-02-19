start:
	DATABASE_URL=postgres://postgres:postgres@localhost/video_tutorials_dev \
		HOST=localhost \
		SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		_build/prod/rel/video_tutorials_prod/bin/video_tutorials_prod start

message_store.init:
	DATABASE_URL=postgres://postgres:postgres@localhost/video_tutorials_dev \
		HOST=localhost \
		SECRET_KEY_BASE=/sILrxwE3wh9hW82srOPSegkPd5y/SjzgW6eMA5VHcOMmpyANwIAdy9kOftjYrhu \
		_build/prod/rel/video_tutorials_prod/bin/video_tutorials_prod eval "Mix.Tasks.MessageStore.Init.run(:foo)"

release:
	MIX_ENV=prod mix do phx.digest, release