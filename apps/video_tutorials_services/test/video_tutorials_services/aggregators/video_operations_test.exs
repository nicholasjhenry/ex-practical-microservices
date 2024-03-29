defmodule VideoTutorialsServices.VideoOperationsTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData

  alias VideoTutorialsData.VideoOperation
  alias VideoTutorialsServices.VideoOperations

  test "handling a video named event" do
    user_id = UUID.uuid4()
    trace_id = UUID.uuid4()
    video_id = UUID.uuid4()

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "videoPublishing-#{video_id}",
        type: "VideoNamed",
        data: %{"name" => "Prod Bugs Hate This Guy: 42 Things You Didn't Know About JS"},
        metadata: %{"userId" => user_id, "traceId" => trace_id},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    VideoOperations.handle_message(event)

    video_operation = Repo.get_by!(VideoOperation, video_id: video_id)
    assert video_operation.trace_id == trace_id
    assert video_operation.succeeded
    refute video_operation.failure_reason
  end

  test "handling a video name rejected event" do
    user_id = UUID.uuid4()
    trace_id = UUID.uuid4()
    video_id = UUID.uuid4()

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "videoPublishing-#{video_id}",
        type: "VideoNameRejected",
        data: %{"name" => "", "reason" => %{name: "Invalid"}},
        metadata: %{"userId" => user_id, "traceId" => trace_id},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    VideoOperations.handle_message(event)

    video_operation = Repo.get_by!(VideoOperation, video_id: video_id)
    refute video_operation.succeeded
    assert video_operation.failure_reason == %{"name" => "Invalid"}
  end
end
