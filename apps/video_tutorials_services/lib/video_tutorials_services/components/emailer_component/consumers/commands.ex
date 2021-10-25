defmodule VideoTutorialsServices.EmailerComponent.Consumers.Commands do
  def child_spec(_) do
    MessageStore.ConsumerWorker.child_spec(
      config: %{
        stream_name: "components:send-email:command",
        subscribed_to: "sendEmail:command",
        handler: VideoTutorialsServices.EmailerComponent.Handlers.Commands
      }
    )
  end
end
