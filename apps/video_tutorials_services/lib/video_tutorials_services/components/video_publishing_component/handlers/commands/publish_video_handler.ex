defmodule VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.PublishVideoHandler do
  use Verity.Messaging.Handler

  import VideoPublishing.TranscodeVideo

  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.PublishVideo
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed
  alias VideoTutorialsServices.VideoPublishingComponent.Store

  defhandle PublishVideo, %{message: command} do
    context = %{video_id: command.video_id, command: command, transcoded_uri: nil}

    with context <- load_video(context),
         {:ok, context} <- ensure_publishing_not_attempted(context),
         {:ok, context} <- transcode_video(context),
         _context <- write_video_published_event(context) do
      :ok
    else
      {:error, {:already_published_error, _context}} -> :ok
      {:error, {_, error, context}} -> write_video_publishing_failed_event(error, context)
    end
  end

  def handle_message(_message_data), do: :ok

  defp load_video(context) do
    Map.put(context, :video, Store.fetch(context.video_id))
  end

  defp ensure_publishing_not_attempted(context) do
    if context.video.publishing_attempted? do
      {:error, {:already_published_error, context}}
    else
      {:ok, context}
    end
  end

  def write_video_published_event(context) do
    command = context.command
    stream_name = stream_name(command.video_id, :videoPublishing)

    command
    |> VideoPublished.follow(%{transcoded_uri: context.transcoded_uri})
    |> write(stream_name)

    context
  end

  # This cannot be called at the moment.
  @dialyzer {:nowarn_function, write_video_publishing_failed_event: 2}

  defp write_video_publishing_failed_event(error, context) do
    command = context.command
    stream_name = stream_name(command.video_id, :videoPublishing)

    command
    |> VideoPublishingFailed.follow(%{reason: error.message})
    |> write(stream_name)

    context
  end
end
