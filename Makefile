start:
	docker-compose up -d

stop:
	docker-compose stop

app.setup: db.setup npm.setup

app.start:
	iex -S mix phx.server

db.console:
	docker-compose exec db  psql -h localhost -U postgres postgres

db.setup:
	mix cmd --app video_tutorials_data mix ecto.drop
	mix cmd --app  video_tutorials_data mix ecto.create
	mix message_store.init
	mix cmd --app video_tutorials_data mix ecto.setup

npm.setup:
	mix cmd --app creators_portal_web npm install --prefix assets
	mix cmd --app video_tutorials_back_office npm install --prefix assets
	mix cmd --app video_tutorials_web npm install --prefix assets