defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.Emailer do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  alias VideoTutorialsServices.IdentityComponent.Handlers

  def child_specs() do
    [
      MessageStore.ConsumerWorker.child_spec(
        config: %{
          stream_name: "components:identity:sendEmailEvents",
          subscribed_to: "sendEmail",
          handler: Handlers.SendEmail.Events,
          opts: [origin_stream_name: "identity"]
        }
      )
    ]
  end
end
