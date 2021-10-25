defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.Emailer do
  # Eventide:
  # include Consumer::Postgres
  # handler Handlers::Commands

  def child_spec do
    {
      MessageStore.ConsumerWorker,
      [
        config: %{
          stream_name: "components:identity:sendEmailEvents",
          subscribed_to: "sendEmail",
          handler: VideoTutorialsServices.IdentityComponent.Handlers.SendEmail.Events,
          opts: [origin_stream_name: "identity"]
        }
      ]
    }
  end
end
