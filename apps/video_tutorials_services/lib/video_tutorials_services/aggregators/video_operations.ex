defmodule VideoTutorialsServices.VideoOperations do
  alias VideoTutorialsData.{Repo, VideoOperation}

  def handle_message(%{type: "VideoNamed"} = event) do
    video_id = stream_to_entity_id(event.stream_name)
    trace_id = Map.fetch!(event.metadata, "traceId")

    Repo.insert!(%VideoOperation{video_id: video_id, trace_id: trace_id, succeeded: true})
  end

  def handle_message(%{type: "VideoNameRejected"} = event) do
    video_id = stream_to_entity_id(event.stream_name)
    trace_id = Map.fetch!(event.metadata, "traceId")
    reason = Map.fetch!(event.data, "reason")

    Repo.insert!(%VideoOperation{
      video_id: video_id,
      trace_id: trace_id,
      succeeded: false,
      failure_reason: reason
    })
  end

  def handle_message(_) do
  end

  defp stream_to_entity_id(stream_name) do
    stream_name
    |> String.split("-", parts: 2)
    |> List.last()
  end
end
