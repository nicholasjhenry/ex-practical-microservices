defmodule VideoTutorialsServices.EmailerComponent do
  def child_specs do
    [
      {
        MessageStore.ConsumerWorker,
        [
          config: %{
            stream_name: "components:send-email:command",
            subscribed_to: "sendEmail:command",
            handler: VideoTutorialsServices.EmailerComponent.Handlers.Commands
          }
        ]
      }
    ]
  end
end
