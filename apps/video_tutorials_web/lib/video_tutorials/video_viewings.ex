defmodule VideoTutorials.VideoViewings do
  alias MessageStore.MessageData

  def record_viewing(video_id) do
    stream_name = "viewing-#{video_id}"

    viewed_event =
      MessageData.Write.new(
        stream_name: stream_name,
        type: "VideoViewed",
        metadata: %{},
        data: %{
          "videoId" => video_id
        },
        expected_version: nil
      )

    # TODO: message_store.write(stream_name, viewed_event) ??
    MessageStore.write_message(viewed_event)
  end
end
