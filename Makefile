dev.start:
	docker-compose up -d

dev.stop:
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

npm.clean:
	mix cmd --app creators_portal_web rm -rf assets/node_modules
	mix cmd --app video_tutorials_back_office rm -rf assets/node_modules
	mix cmd --app video_tutorials_web rm -rf assets/node_modules

# Run if this message is displayed:
#  Error: Node Sass does not yet support your current environment: OS X 64-bit with Unsupported runtime (93)
npm.sass.rebuild:
	mix cmd --app creators_portal_web npm rebuild node-sass --prefix assets
	mix cmd --app video_tutorials_back_office npm rebuild node-sass --prefix assets
	mix cmd --app video_tutorials_web npm rebuild node-sass --prefix assets
