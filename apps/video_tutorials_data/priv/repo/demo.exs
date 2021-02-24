# Write a new video published event

video_id = Ecto.UUID.generate()
stream_name = "videoPublishing-#{video_id}"

video_published_event = MessageStore.NewMessage.new(
  stream_name: stream_name,
  type: "videoPublished",
  metadata: %{
    trace_id: Ecto.UUID.generate(),
    user_id: Ecto.UUID.generate(),
  },
  data: %{
    owner_id: "1F2D2A6F-47DB-477F-9C48-7A706AF3A038",
    source_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA",
    transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA",
    video_id: video_id
  },
  expected_version: nil
)

MessageStore.write_message(video_published_event)
