defmodule VideoTutorialsServices.VideoPublishingComponent.Consumers.Commands do
  alias VideoTutorialsServices.VideoPublishingComponent.Commands

  def child_specs do
    [
      MessageStore.ConsumerWorker.child_spec(
        config: %{
          stream_name: "components:name-video",
          subscribed_to: "videoPublishing:command",
          handler: Commands.NameVideoHandler
        }
      ),
      MessageStore.ConsumerWorker.child_spec(
        config: %{
          stream_name: "components:publishing-video",
          subscribed_to: "videoPublishing:command",
          handler: Commands.PublishVideoHandler
        }
      )
    ]
  end
end
