defmodule VideoTutorialsServices.EmailerComponent.Consumers.Commands do
  alias VideoTutorialsServices.EmailerComponent.Handlers

  def child_specs() do
    [
      MessageStore.ConsumerWorker.child_spec(
        config: %{
          stream_name: "components:send-email:command",
          subscribed_to: "sendEmail:command",
          handler: Handlers.Commands
        }
      )
    ]
  end
end
