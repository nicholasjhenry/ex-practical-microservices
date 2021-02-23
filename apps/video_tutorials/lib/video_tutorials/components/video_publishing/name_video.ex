defmodule VideoTutorials.VideoPublishing.NameVideo do
  alias MessageStore.NewMessage
  alias VideoTutorials.VideoPublishing.VideoPublishingProjection

  def handle_message(%{type: "NameVideo"} = command) do
    context = %{video_id: command.data["video_id"], command: command}

    with context = load_video(context),
          {:ok, context} <- ensure_command_has_not_been_processed(context),
          {:ok, context} <- ensure_name_is_valid(context),
          _context = write_video_named_event(context) do
            :ok
    else
      {:error, {:command_already_processed, _context}} -> :ok
      {:error, {:validation_error, changeset, context}} -> write_video_name_rejected(context, changeset.errors)
    end
  end

  defp load_video(context) do
    video_stream_name = "videoPublishing-#{context.video_id}"

    maybe_video = MessageStore.fetch(video_stream_name, VideoPublishingProjection)

    Map.put(context, :video, maybe_video)
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
    import Ecto.Changeset

    command = context.command
    types = %{name: :string}

    {context.video, types}
    |> cast(%{name: command.data["name"]}, Map.keys(types))
    |> validate_required(~w/name/a)
    |> apply_action(:insert)
    |> case do
      {:ok, _valid_input} -> {:ok, context}
      {:error, changeset} -> {:error, {:validation_error, changeset, context}}
    end
  end

  defp write_video_named_event(context) do
    command = context.command

    stream_name = "videoPublishing-#{command.data["video_id"]}"

    video_named_event = NewMessage.new(
      stream_name: stream_name,
      type: "VideoNamed",
      metadata: %{
        trace_id: Map.fetch!(command.metadata, "trace_id"),
        user_id: Map.fetch!(command.metadata, "user_id"),
      },
      data: %{
        name: Map.fetch!(command.data, "name")
      },
      # TODO
      expected_version: nil
    )

    MessageStore.write_message(video_named_event)

    context
  end

  defp write_video_name_rejected(context, errors) do
    command = context.command

    stream_name = "videoNamed-#{command.data["video_id"]}"

    reason =
      errors
      |> Enum.map(fn {field, {msg, _metadata}} -> {field, msg} end)
      |> Map.new

    video_name_rejected_event = NewMessage.new(
      stream_name: stream_name,
      type: "VideoNameRejected",
      metadata: %{
        trace_id: Map.fetch!(command.metadata, "trace_id"),
        user_id: Map.fetch!(command.metadata, "user_id"),
      },
      data: %{
        name: Map.fetch!(command.data, "name"),
        reason: reason
      },
      # TODO
      expected_version: nil
    )

    MessageStore.write_message(video_name_rejected_event)

    context
  end
end
