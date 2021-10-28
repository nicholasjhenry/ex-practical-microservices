defmodule VideoTutorialsServices.CreatorsVideosTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData
  alias VideoTutorialsData.Video
  alias VideoTutorialsServices.CreatorsVideos

  test "handling a video named event" do
    video =
      Repo.insert!(%Video{
        owner_id: UUID.uuid4(),
        name: "Untitled",
        description: "TBD",
        source_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA",
        transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA"
      })

    user_id = UUID.uuid4()
    trace_id = UUID.uuid4()
    video_id = video.id

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "videoPublishing-#{video_id}",
        type: "VideoNamed",
        data: %{"name" => "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS"},
        metadata: %{"userId" => user_id, "traceId" => trace_id},
        position: 1,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    CreatorsVideos.handle_message(event)

    updated_video = Repo.get!(Video, video_id)
    assert updated_video.name == "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS"
  end
end
