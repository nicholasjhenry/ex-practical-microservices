defmodule VideoTutorialsServices.VideoPublishingComponent do
  def child_specs do
    [
      {
        MessageStore.ConsumerWorker,
        [
          config: %{
            stream_name: "components:name-video",
            subscribed_to: "videoPublishing:command",
            handler: VideoTutorialsServices.VideoPublishingComponent.Commands.NameVideoHandler
          }
        ]
      },
      {
        MessageStore.ConsumerWorker,
        [
          config: %{
            stream_name: "components:publishing-video",
            subscribed_to: "videoPublishing:command",
            handler: VideoTutorialsServices.VideoPublishingComponent.Commands.PublishVideoHandler
          }
        ]
      }
    ]
  end
end
