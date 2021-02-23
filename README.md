# Video Tutorials

Status: `in-progress`

This is an exploration of message-based systems based on the book Practical Microservices.
Do not consider this code production ready, quality Elixir code or complete test coverage. My
intention here is to move as quickly as possible to demonstrate the approach to developing
applications. I hope to iterate on this repo in the future to improve the code and test quality.

## Structure of message-based systems

Five categories in a message-based system, [Practical Microservices](https://pragprog.com/titles/egmicro/practical-microservices/) pg 23:

> * __Applications__: If you’ve done MVC CRUD, then everything you built is properly understood as
>   an Application. They have the HTTP endpoints and are what our end users interact with. The
>   operate in a request/response mode, providing immediate responses to user input.
> * __Components__: Autonomous Components are doers of things. A Component encapsulates a distinct
>   business process. They operate in batch mode, processing batches of messages as they become
>   available.
> * __Aggregators__: Aggregators aggregate state transitions into View Data that Applications use to
>   render what end users see. As with Components, they also operate in batch mode, processing batches
>   of messages as they become available.
> * __View Data__: View Data are read-only models derived from state transitions. They are not
>   authoritative state, but are eventually consistent derivations from authoritative state. As such,
>   we don’t make decisions based on View Data, hence why it’s called View Data. In this book we’ll
>   use PostgreSQL tables for our View Data, but truly, they could be anything from generated static
>   files to Elasticsearch to Neo4j.
> * __Message Store__: At the center of it all is the Message Store. The state transitions we're using as
>   authoritative state live here. It is at the same time a durable state store as well as a transport
>   mechanism.

## Setup

    mix cmd --app video_tutorials mix ecto.create
    mix cmd --app video_tutorials mix message_store.init
    mix cmd --app video_tutorials mix ecto.setup

## Deploy on Heroku

    heroku apps:create --stack=container --addons heroku-postgresql:standard-0 # THIS WILL COST MONEY
    heroku config:add SECRET_KEY_BASE={secret} HOST={app_name}.herokuapp.com
    heroku pg:wait
    heroku pg:credentials:create {database_name} --name message_store
    heroku addons:attach {database_name} --credential message_store -a {app_name}
    git push heroku HEAD:master
    heroku run /app/bin/db_demo