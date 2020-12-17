start:
	docker-compose up -d

stop:
	docker-compose stop

app.start:
	iex -S mix phx.server