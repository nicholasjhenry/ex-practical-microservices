defmodule VideoTutorialsServices.IdentityComponent.Consumers.Commands do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  alias VideoTutorialsServices.IdentityComponent.Handlers

  def child_specs() do
    [
      MessageStore.ConsumerWorker.child_spec(
        config: %{
          stream_name: "components:identity:command",
          subscribed_to: "identity:command",
          handler: Handlers.Commands
        }
      )
    ]
  end
end
