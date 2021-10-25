defmodule VideoTutorialsServices.IdentityComponent.Consumers.Commands do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  def child_spec do
    {
      MessageStore.ConsumerWorker,
      [
        config: %{
          stream_name: "components:identity:command",
          subscribed_to: "identity:command",
          handler: VideoTutorialsServices.IdentityComponent.Handlers.Commands
        }
      ]
    }
  end
end
