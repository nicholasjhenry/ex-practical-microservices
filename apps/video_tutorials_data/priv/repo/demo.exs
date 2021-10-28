# Write a new video published event

video_id = Ecto.UUID.generate()
stream_name = "videoPublishing-#{video_id}"

video_published_event =
  MessageStore.MessageData.Write.new(
    stream_name: stream_name,
    type: "VideoPublished",
    metadata: %{
      "traceId" => Ecto.UUID.generate(),
      "userId" => Ecto.UUID.generate()
    },
    data: %{
      "ownerId" => "1F2D2A6F-47DB-477F-9C48-7A706AF3A038",
      "sourceUri" => "https://www.youtube.com/watch?v=GI_P3UtZXAA",
      "transcodedUri" => "https://www.youtube.com/watch?v=GI_P3UtZXAA",
      "videoId" => video_id
    },
    expected_version: nil
  )

MessageStore.write_message(video_published_event)
