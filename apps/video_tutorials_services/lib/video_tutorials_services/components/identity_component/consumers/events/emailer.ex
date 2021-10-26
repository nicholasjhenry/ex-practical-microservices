defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.Emailer do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  @identifier "identity"

  alias VideoTutorialsServices.IdentityComponent.Handlers

  def child_spec(opts) do
    stream_name = Keyword.fetch!(opts, :stream_name)

    MessageStore.ConsumerWorker.child_spec(
      config: %{
        stream_name: stream_name <> "+position" <> "-" <> @identifier,
        subscribed_to: stream_name,
        handler: Handlers.Commands
      }
    )
  end
end
