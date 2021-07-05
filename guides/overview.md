# Introduction

## Application Structure

The Video Tutorials platform is composed of several applications:

* [Creators Portal (Web)](./creators_portal/index.html): manage videos
* [Back Office](./video_tutorials_back_office/index.html): back office application for viewing the health of the platform
* [Data](./video_tutorials_data/index.html): database application including repo and schemas
* [Services](./video_tutorials_services/index.html): contains aggregrators and components
* [Video Tutorials (Web)](./video_tutorials_web/index.html): public access to view video tutorials, register and login

TODO Message Store documentation

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