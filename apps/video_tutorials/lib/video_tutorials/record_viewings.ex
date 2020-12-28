defmodule VideoTutorials.RecordViewings do
  alias MessageStore.NewMessage

  def record_viewing(trace_id, video_id, user_id) do
    stream_name = "viewing-#{video_id}"

    viewed_event = NewMessage.new(
      stream_name: stream_name,
      type: "VideoViewed",
      metadata: %{
        trace_id: trace_id,
        user_id: user_id
      },
      data: %{
        user_id: user_id,
        video_id: video_id
      },
      expected_version: nil
    )

    # TODO: message_store.write(stream_name, viewed_event) ??
    MessageStore.write_message(viewed_event)
  end
end
