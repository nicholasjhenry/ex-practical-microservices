defmodule VideoTutorialsServices.VideoPublishingComponent.Commands.NameVideoHandler do
  import Verity.Messaging.Handle
  import Verity.Messaging.StreamName
  import Verity.Messaging.Write

  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected
  alias VideoTutorialsServices.VideoPublishingComponent.Store
  alias VideoTutorialsServices.VideoPublishingComponent.VideoPublishing

  @category :videoPublishing

  defmodule Context do
    defstruct [:video_id, :command]
  end

  def handle_message(%{type: "NameVideo"} = command) do
    name_video(command)
    command
  end

  def handle_message(command), do: command

  defp name_video(command) do
    context = %Context{video_id: command.data["video_id"], command: command}

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

  defp load_video(context) do
    Map.put(context, :video, Store.fetch(context.video_id))
  end

  defp ensure_command_has_not_been_processed(context) do
    command = context.command
    video = context.video

    if video.sequence > command.global_position do
      {:error, {:command_already_processed, context}}
    else
      {:ok, context}
    end
  end

  defp ensure_name_is_valid(context) do
    case VideoPublishing.changeset(context.video, context.command.data) do
      {:ok, _valid_input} -> {:ok, context}
      {:error, changeset} -> {:error, {:validation_error, changeset, context}}
    end
  end

  defp write_video_named_event(context) do
    name_video = context.command
    stream_name = stream_name(name_video.data["video_id"], @category)

    name_video
    |> VideoNamed.follow()
    |> write(stream_name)

    context
  end

  defp write_video_name_rejected(context, errors) do
    name_video = context.command
    stream_name = stream_name(name_video.data["video_id"], @category)

    reason =
      errors
      |> Enum.map(fn {field, {msg, _metadata}} -> {field, msg} end)
      |> Map.new()

    name_video
    |> VideoNameRejected.follow(reason)
    |> write(stream_name)

    context
  end
end
