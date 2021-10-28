defmodule VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.PublishVideoHandler do
  use Verity.Messaging.Handler

  import VideoPublishing.TranscodeVideo

  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed
  alias VideoTutorialsServices.VideoPublishingComponent.Store

  @category :videoPublishing

  @impl true
  def handle_message(%{type: "PublishVideo"} = command), do: publish_video(command)
  def handle_message(_command), do: :ok

  defp publish_video(command) do
    context = %{video_id: command.data["videoId"], command: command, transcoded_uri: nil}

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

    stream_name = stream_name(command.data["videoId"], @category)

    video_published =
      VideoPublished.new(
        %{
          "traceId" => Map.fetch!(command.metadata, "traceId"),
          "userId" => Map.fetch!(command.metadata, "userId")
        },
        %{
          "ownerId" => Map.fetch!(command.data, "ownerId"),
          "sourceUri" => Map.fetch!(command.data, "sourceUri"),
          "transcodedUri" => context.transcoded_uri,
          "videoId" => Map.fetch!(command.data, "videoId")
        }
      )

    write(video_published, stream_name)

    context
  end

  # This cannot be called at the moment.
  @dialyzer {:nowarn_function, write_video_publishing_failed_event: 2}

  defp write_video_publishing_failed_event(error, context) do
    command = context.command

    stream_name = stream_name(command.data["videoId"], @category)

    video_publishing_failed =
      VideoPublishingFailed.new(
        %{
          "traceId" => Map.fetch!(command.metadata, "traceId"),
          "userId" => Map.fetch!(command.metadata, "userId")
        },
        %{
          "ownerId" => Map.fetch!(command.data, "ownerId"),
          "sourceUri" => Map.fetch!(command.data, "sourceUri"),
          "videoId" => Map.fetch!(command.data, "videoId"),
          "reason" => error.message
        }
      )

    write(video_publishing_failed, stream_name)

    context
  end
end
