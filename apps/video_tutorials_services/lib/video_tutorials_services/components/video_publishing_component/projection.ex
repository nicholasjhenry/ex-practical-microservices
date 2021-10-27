defmodule VideoTutorialsServices.VideoPublishingComponent.Projection do
  use Verity.EntityProjection

  alias VideoTutorialsServices.VideoPublishingComponent.VideoPublishing

  @impl true
  def init() do
    %VideoPublishing{publishing_attempted?: false, sequence: 0, name: ""}
  end

  @impl true
  def apply(video, %{type: "videoPublished", data: data, global_position: global_position}) do
    %{
      video
      | id: data["video_id"],
        publishing_attempted?: true,
        owner_id: data["owner_id"],
        source_uri: data["source_uri"],
        transcoded_uri: data["transcoded_uri"],
        sequence: global_position
    }
  end

  def apply(video, %{type: "videoFailed", data: data, global_position: global_position}) do
    %{
      video
      | id: data["video_id"],
        publishing_attempted?: true,
        owner_id: data["owner_id"],
        source_uri: data["source_uri"],
        transcoded_uri: data["transcoded_uri"],
        sequence: global_position
    }
  end

  def apply(video, %{type: "VideoNamed", data: data, global_position: global_position}) do
    %{video | name: data["name"], sequence: global_position}
  end

  def apply(video, %{type: "VideoNameRejected", data: data, global_position: global_position}) do
    %{video | name: data["name"], sequence: global_position}
  end
end
