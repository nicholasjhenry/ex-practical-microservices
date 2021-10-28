defmodule VideoTutorialsServices.VideoPublishingComponent.Commands.PublishVideoHandlerTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData

  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.PublishVideoHandler
  alias VideoTutorialsServices.VideoPublishingComponent.Projection

  test "publishing a video" do
    command =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: command_stream_name(1, :videoPublishing),
        type: "PublishVideo",
        data: %{
          "ownerId" => "bb6a04b0-cb74-4981-b73d-24b844ca334f",
          "sourceUri" => "https://sourceurl.com/",
          "videoId" => "1"
        },
        metadata: %{"traceId" => UUID.uuid4(), "userId" => UUID.uuid4()},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    PublishVideoHandler.handle_message(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", Projection)
    assert video_publishing.id == "1"
    assert video_publishing.transcoded_uri == "https://www.youtube.com/watch?v=GI_P3UtZXAA"
  end
end
