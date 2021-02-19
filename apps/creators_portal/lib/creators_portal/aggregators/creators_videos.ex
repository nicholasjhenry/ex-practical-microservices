defmodule CreatorsPortal.CreatorsVideos do
  alias VideoTutorials.Repo
  alias CreatorsPortal.Video

  import Ecto.Query

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
