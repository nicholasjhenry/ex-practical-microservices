defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  alias VideoTutorialsServices.IdentityComponent.Handlers

  def child_spec(opts) do
    stream_name = Keyword.fetch!(opts, :stream_name)

    MessageStore.ConsumerWorker.child_spec(
      config: %{
        stream_name: stream_name <> "+position",
        subscribed_to: stream_name,
        handler: Handlers.Events
      }
    )
  end
end
