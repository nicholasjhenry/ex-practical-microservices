# Video Tutorials

## Project Status

Status: `in-progress`

This is an exploration of message-based systems based on the book **Practical Microservices**.
Do not consider this code production ready, quality Elixir code or complete test coverage. My
intention here is to move as quickly as possible to demonstrate the approach to developing
applications. I hope to iterate on this repo in the future to improve the code and test quality.

## Why this example application

CRUD applications for non-trival applications are hurting us. I want to help promote an alternative
with message-based architectures in Elixir as the default approach. The book
Practical Microservices (which perhaps I would have called Practical Message-based Applications),
provides a uniquely approachable introduction to this style of architecture.

Thank you so much, [@EthanGarofolo](https://twitter.com/EthanGarofolo).

## Getting Started

To understand what this is all about, I recommend reading the book [Practical Microservices](https://pragprog.com/titles/egmicro/practical-microservices/)
that this example application was ported from, originally written in JavaScript.

To learn about this implentation, read the documentation:

```
  mix docs
  open doc/index.html
```

## Setup

    mix cmd --app video_tutorials mix ecto.create
    mix cmd --app video_tutorials mix message_store.init
    mix cmd --app video_tutorials mix ecto.setup
## Running

    make start
    iex -S mix phx.server

* Main site: http://localhost:4000/
* Creator's Portal: http://localhost:4000/creators_portal
* Backoffice: http://localhost:4000/admin
