start:
	docker-compose up -d

stop:
	docker-compose stop

app.start:
	iex -S mix phx.server

db.console:
	docker-compose exec db  psql -h localhost -U postgres postgres