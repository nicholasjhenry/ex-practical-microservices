defmodule VideoTutorials.VideoOperations do
  alias VideoTutorials.{Repo, VideoOperation}

  def handle_message(%{type: "VideoNamed"} = event) do
    video_id = stream_to_entity_id(event.stream_name)
    trace_id = Map.fetch!(event.metadata, "trace_id")

    Repo.insert!(%VideoOperation{video_id: video_id, trace_id: trace_id, succeeded: true})
  end

  def handle_message(%{type: "VideoNameRejected"} = event) do
    video_id = stream_to_entity_id(event.stream_name)
    trace_id = Map.fetch!(event.metadata, "trace_id")
    reason = Map.fetch!(event.data, "reason")

    Repo.insert!(%VideoOperation{video_id: video_id, trace_id: trace_id, succeeded: false, failure_reason: reason})
  end

  def handle_message(_) do
  end

  defp stream_to_entity_id(stream_name) do
    stream_name
    |> String.split("-", parts: 2)
    |> List.last
  end
end
