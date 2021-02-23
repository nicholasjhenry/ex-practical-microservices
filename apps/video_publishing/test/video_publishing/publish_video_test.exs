defmodule VideoPublishing.PublishVideoTest do
  use VideoTutorials.DataCase

  alias VideoPublishing.{VideoPublishingProjection, PublishVideo}
  alias MessageStore.Message

  test "publishing a video" do
    command = Message.new(
      id: UUID.uuid4,
      stream_name: "videoPublishing:command-1",
      type: "PublishVideo",
      data: %{
        "owner_id" => "bb6a04b0-cb74-4981-b73d-24b844ca334f", "source_uri" => "https://sourceurl.com/", "video_id" => "1"
      },
      metadata: %{"trace_id" => UUID.uuid4, "user_id" => UUID.uuid4},
      position: 0,
      global_position: 11,
      time: NaiveDateTime.local_now()
    )

    PublishVideo.handle_message(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", VideoPublishingProjection)
    assert video_publishing.id == "1"
    assert video_publishing.transcoded_uri == "https://www.youtube.com/watch?v=GI_P3UtZXAA"
  end
end
