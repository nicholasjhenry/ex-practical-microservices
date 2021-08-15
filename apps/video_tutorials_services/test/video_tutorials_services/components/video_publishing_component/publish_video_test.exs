defmodule VideoTutorialsServices.VideoPublishingComponent.Commands.PublishVideoHandlerTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData

  alias VideoTutorialsServices.VideoPublishingComponent.Commands.PublishVideoHandler
  alias VideoTutorialsServices.VideoPublishingComponent.Projection

  test "publishing a video" do
    command =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "videoPublishing:command-1",
        type: "PublishVideo",
        data: %{
          "owner_id" => "bb6a04b0-cb74-4981-b73d-24b844ca334f",
          "source_uri" => "https://sourceurl.com/",
          "video_id" => "1"
        },
        metadata: %{"trace_id" => UUID.uuid4(), "user_id" => UUID.uuid4()},
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
