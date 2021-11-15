defmodule VideoTutorialsServices.VideoPublishingComponent.Commands.PublishVideoHandlerTest do
  use VideoTutorialsServices.DataCase

  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.PublishVideoHandler
  alias VideoTutorialsServices.VideoPublishingComponent.Projection
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.PublishVideo

  test "publishing a video" do
    command =
      PublishVideo.build(
        %{trace_id: UUID.uuid4(), user_id: UUID.uuid4()},
        %{
          owner_id: "bb6a04b0-cb74-4981-b73d-24b844ca334f",
          source_uri: "https://sourceurl.com/",
          video_id: "1"
        }
      )

    PublishVideoHandler.handle(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", Projection)
    assert video_publishing.id == "1"
    assert video_publishing.transcoded_uri == "https://www.youtube.com/watch?v=GI_P3UtZXAA"
  end
end
