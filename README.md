# MsgService

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# What is MsgService?

The serivice will be used in order to listen and get message from other application sthat can then be passed off to the main leafnode application to trigger nodes. The messages can be from anything but maily will be used to handle email hook information.

# How does it work?

The system will be setup to listen through exposing web hooks to the other application. The other application will then send a message to the service and the service will then trigger the nodes.

The webhooks will be tied to catching specific services and then process by passing along to relevant modules that will then have the service send messages to an internal leafnode application.

The internal API on the leafnode application will be responsible for taking the data as well as giving access to requested database information for the this service in order to then trigger the nodes.

# Architecture
![High-Level Architecture](./docs/high%20level%20overview.svg)

Note: This is the high level overview of the architecture. The user interaction, services that will be used and how the systems will interact to get the relevvant data in order to execute the nodes.

There will be systems setup in place to manage the message load, queues, retrys etc. This will be setup to allow the system to scale and be able to handle the load from the services (multiple) that will be sending messages to the system.
