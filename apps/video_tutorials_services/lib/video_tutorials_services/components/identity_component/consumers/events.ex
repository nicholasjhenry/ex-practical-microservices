defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  alias VideoTutorialsServices.IdentityComponent.Handlers

  def child_specs() do
    [
      MessageStore.ConsumerWorker.child_spec(
        config: %{
          stream_name: "components:identity",
          subscribed_to: "identity",
          handler: Handlers.Events
        }
      )
    ]
  end
end
