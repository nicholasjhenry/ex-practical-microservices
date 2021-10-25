defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  def child_spec do
    {
      MessageStore.ConsumerWorker,
      [
        config: %{
          stream_name: "components:identity",
          subscribed_to: "identity",
          handler: VideoTutorialsServices.IdentityComponent.Handlers.Events
        }
      ]
    }
  end
end
