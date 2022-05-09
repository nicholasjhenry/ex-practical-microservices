defmodule VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands.NameVideoHandler do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.NameVideo
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected
  alias VideoTutorialsServices.VideoPublishingComponent.Store
  alias VideoTutorialsServices.VideoPublishingComponent.VideoPublishing

  defmodule Context do
    defstruct [:video_id, :command, :video, :version]
  end

  def handle_message(%NameVideo{} = command) do
    context = %Context{video_id: command.video_id, command: command}

    with context <- load_video(context),
         {:ok, context} <- ensure_command_has_not_been_processed(context),
         {:ok, context} <- ensure_name_is_valid(context),
         _context <- write_video_named_event(context) do
      :ok
    else
      {:error, {:command_already_processed, _context}} ->
        :ok

      {:error, {:validation_error, changeset, context}} ->
        write_video_name_rejected(context, changeset.errors)
    end
  end

  def handle_message(_message_data), do: :ok

  defp load_video(context) do
    {video, version} = Store.fetch(context.video_id, include: [:version])
    %{context | video: video, version: version}
  end

  defp ensure_command_has_not_been_processed(context) do
    command = context.command
    video = context.video

    if video.sequence > command.metadata.global_position do
      {:error, {:command_already_processed, context}}
    else
      {:ok, context}
    end
  end

  defp ensure_name_is_valid(context) do
    case VideoPublishing.changeset(context.video, context.command) do
      {:ok, _valid_input} -> {:ok, context}
      {:error, changeset} -> {:error, {:validation_error, changeset, context}}
    end
  end

  defp write_video_named_event(context) do
    name_video = context.command
    stream_name = stream_name(name_video.video_id, :videoPublishing)

    name_video.metadata
    |> VideoNamed.build(%{name: name_video.name})
    |> write(stream_name, expected_version: context.version)

    context
  end

  defp write_video_name_rejected(context, errors) do
    name_video = context.command
    stream_name = stream_name(name_video.video_id, :videoPublishing)

    reason =
      errors
      |> Enum.map(fn {field, {msg, _metadata}} -> {field, msg} end)
      |> Map.new()

    name_video.metadata
    |> VideoNameRejected.build(%{name: name_video.name, reason: reason})
    |> write(stream_name, expected_version: context.version)

    context
  end
end
