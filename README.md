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

## Videos - Ethan Garofolo

* [2019 - Building UI's for Microservices -  wroc_love.rb](https://www.youtube.com/watch?v=ArTS_AJ-smQ)
  * [Mailing List](http://tinyurl.com/microservices-mailing-list)
  * [Slides](https://docs.google.com/presentation/d/1CesA2EgQbVT5Q02Phc_Ia445ac3GDc4WSdrTIcZX5UU/)
* [Idempotence: Build Mission Critical Systems *and* Keep Your Job](https://www.youtube.com/watch?v=vmPqi8mHHis)
  * [Patterns of Service-oriented Architecture: Idempotency Key](https://multithreaded.stitchfix.com/blog/2017/06/26/patterns-of-soa-idempotency-key/)
  * [Slides](https://docs.google.com/presentation/d/1AbwPjV5Nf8RFu4hwnjWCfmfhev8JqgIqjMHCsA2tWWo/)
* [Microservices, Monoliths, and Event Stores](https://www.youtube.com/watch?v=ELTZkbHJ-Xg)
* [2018 Getting data out of microservices - 14 August](https://www.youtube.com/watch?v=XL0Ie_Gn39M)
* [2018 Building an Event Store - Ethan Garofolo - 8 May](https://www.youtube.com/watch?v=J-xisAm3P-I)
* [Validation in an eventually consistent world](https://www.youtube.com/watch?v=tlbr7i1_blA)
* [Choreography vs Orchestration in long running asynchronous processes](https://www.youtube.com/watch?v=ofJd3AZIfto)
* [2017 Node.js Microservices - Utah JS SLC - 16 May](https://www.youtube.com/watch?v=h8ihxzfqH0A)
* [2017 Event Sourcing - Utah Node.js Meetup 13 June](https://www.youtube.com/watch?v=JWTT5KV4Lr0)
## Video - Eventide

* [Event Sourcing Anti Patterns and Failures - Nathan Ladd - wroc_love.rb 2018](https://www.youtube.com/watch?v=vh1QTk34350)
* [GORUCO 2018: Evented Autonomous Services in Ruby by Scott Bellware](https://www.youtube.com/watch?v=qgKlu5gFsJM)
* [The Aggregate, The Cohesion, And The Cargo Cult - Scott Bellware and Nathan Ladd - Explore DDD 2017](https://www.youtube.com/watch?v=sb-WO-KcODE)
* [Distributed Fizz Buzz... by Nathan Ladd & Scott Bellware - Keep Ruby Weird 2018](https://www.youtube.com/watch?v=B9HlY1SsBA0)
* [Event Sourcing Tutorial in Ruby - Joseph Choe](https://www.youtube.com/watch?v=dfAzp9pxp9c)
* [Event Sourcing - Snapshots - Joesph Choe](https://www.youtube.com/watch?v=dfAzp9pxp9c)

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
