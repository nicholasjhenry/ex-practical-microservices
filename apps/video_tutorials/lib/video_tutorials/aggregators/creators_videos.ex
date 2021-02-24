defmodule VideoTutorials.CreatorsVideos do
  alias VideoTutorialsData.Repo
  alias VideoTutorials.Video

  import Ecto.Query

  def handle_message(%{type: "videoPublished"} = event) do
    video_id = stream_to_entity_id(event.stream_name)
    position = event.position
    owner_id = Map.fetch!(event.data, "owner_id")
    source_uri = Map.fetch!(event.data, "source_uri")
    transcoded_uri = Map.fetch!(event.data, "transcoded_uri")

    video = %Video{
      id: video_id,
      owner_id: owner_id,
      name: "Untitled",
      description: "No description",
      views: 0,
      source_uri: source_uri,
      transcoded_uri: transcoded_uri,
      position: position
    }

    Repo.insert!(video, on_conflict: :nothing)
  end

  def handle_message(%{type: "VideoNamed"} = event) do
    video_id = stream_to_entity_id(event.stream_name)
    position = event.position
    name = Map.fetch!(event.data, "name")

    from(v in Video, where: v.position < ^position and v.id == ^video_id, update: [set: [name: ^name, position: ^position]])
    |> Repo.update_all([])
  end

  def handle_message(_) do
    ## Add logger
  end

  defp stream_to_entity_id(stream_name) do
    stream_name
    |> String.split("-", parts: 2)
    |> List.last
  end
end
