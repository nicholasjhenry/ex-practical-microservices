defmodule VideoTutorials.VideoPublishing do
  alias __MODULE__.{TranscodeVideo, VideoPublishingProjection}
  alias MessageStore.NewMessage

  def handle_message(%{type: "PublishVideo"} = command) do
    context = %{video_id: command.data["video_id"], command: command, transcoded_uri: nil}

    with context = load_video(context),
          {:ok, context} <- ensure_publishing_not_attempted(context),
          {:ok, context} <- transcode_video(context),
          _context = write_video_published_event(context) do
            :ok
    else
      {:error, {:already_published_error, _context}} -> :ok
      {:error, {_, error, context}} -> write_video_publishing_failed_event(error, context)
    end
  end

  defp load_video(context) do
    video_stream_name = "videoPublishing-#{context.video_id}"

    maybe_video = MessageStore.fetch(video_stream_name, VideoPublishingProjection)

    Map.put(context, :video, maybe_video)
  end

  defp ensure_publishing_not_attempted(context) do
    if context.video.publishing_attempted? do
      {:error, {:already_published_error, context}}
    else
      {:ok, context}
    end
  end

  defp transcode_video(context) do
    TranscodeVideo.transcode_video(context)
  end

  defp write_video_published_event(context) do
    command = context.command

    stream_name = "videoPublishing-#{command.data["video_id"]}"

    video_published_event = NewMessage.new(
      stream_name: stream_name,
      type: "videoPublished",
      metadata: %{
        trace_id: Map.fetch!(command.metadata, "trace_id"),
        user_id: Map.fetch!(command.metadata, "user_id"),
      },
      data: %{
        owner_id: Map.fetch!(command.data, "owner_id"),
        source_uri: Map.fetch!(command.data, "source_uri"),
        transcoded_uri: context.transcoded_uri,
        video_id: Map.fetch!(command.data, "video_id")
      },
      # TODO
      expected_version: nil
    )

    MessageStore.write_message(video_published_event)

    context
  end

  defp write_video_publishing_failed_event(error, context) do
    command = context.command

    stream_name = "videoPublishing-#{command.data["video_id"]}"

    video_published_event = NewMessage.new(
      stream_name: stream_name,
      type: "videoPublishingFailed",
      metadata: %{
        trace_id: Map.fetch!(command.metadata, "trace_id"),
        user_id: Map.fetch!(command.metadata, "user_id"),
      },
      data: %{
        owner_id: Map.fetch!(command.data, "owner_id"),
        source_uri: Map.fetch!(command.data, "source_uri"),
        video_id: Map.fetch!(command.data, "video_id"),
        reason: error.message
      },
      # TODO
      expected_version: nil
    )

    MessageStore.write_message(video_published_event)

    context
  end
end
