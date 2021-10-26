defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.SendEmail do
  # import Verity.Consumer.Postgres

  alias VideoTutorialsServices.IdentityComponent.Handlers
  # TODO: Add identifier macro
  # identifier "identity"
  # handler Handlers.Events.SendEmail

  @identifier "identity"

  def child_spec(opts) do
    stream_name = Keyword.fetch!(opts, :stream_name)

    MessageStore.ConsumerWorker.child_spec(
      config: %{
        stream_name: stream_name <> "+position" <> "-" <> @identifier,
        subscribed_to: stream_name,
        handler: Handlers.Events.SendEmail
      }
    )
  end
end
