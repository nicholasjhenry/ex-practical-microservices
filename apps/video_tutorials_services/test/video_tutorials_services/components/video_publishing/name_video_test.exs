defmodule VideoPublishing.NameVideoTest do
  use VideoTutorialsServices.DataCase

  alias VideoPublishing.{PublishVideo, NameVideo, VideoPublishingProjection}
  alias MessageStore.Message

  test "name a video with valid data" do
    publish_video()

    command = Message.new(
      id: UUID.uuid4,
      stream_name: "videoPublishing:command-2",
      type: "NameVideo",
      data: %{
        "name" => "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS", "video_id" => "1"
      },
      metadata: %{"trace_id" => UUID.uuid4, "user_id" => UUID.uuid4},
      position: 1,
      global_position: 12,
      time: NaiveDateTime.local_now()
    )

    NameVideo.handle_message(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", VideoPublishingProjection)
    assert video_publishing.id == "1"
    assert video_publishing.name == "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS"
  end

  test "name a video with invalid data" do
    publish_video()

    command = Message.new(
      id: UUID.uuid4,
      stream_name: "videoPublishing:command-2",
      type: "NameVideo",
      data: %{
        "name" => "", "video_id" => "1"
      },
      metadata: %{"trace_id" => UUID.uuid4, "user_id" => UUID.uuid4},
      position: 1,
      global_position: 12,
      time: NaiveDateTime.local_now()
    )

    NameVideo.handle_message(command)

    video_publishing = MessageStore.fetch("videoPublishing-1", VideoPublishingProjection)
    assert video_publishing.id == "1"
    assert video_publishing.name == ""
  end

  def publish_video do
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

    context = %{command: command, transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA"}
    PublishVideo.write_video_published_event(context)
  end
end
