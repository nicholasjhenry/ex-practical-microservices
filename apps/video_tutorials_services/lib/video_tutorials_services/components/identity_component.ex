defmodule VideoTutorialsServices.IdentityComponent do
  def child_specs do
    [
      {
        MessageStore.ConsumerWorker,
        [
          config: %{
            stream_name: "components:identity:command",
            subscribed_to: "identity:command",
            handler: VideoTutorialsServices.IdentityComponent.Handlers.Commands
          }
        ]
      },
      {
        MessageStore.ConsumerWorker,
        [
          config: %{
            stream_name: "components:identity",
            subscribed_to: "identity",
            handler: VideoTutorialsServices.IdentityComponent.Handlers.Events
          }
        ]
      },
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
    ]
  end
end
