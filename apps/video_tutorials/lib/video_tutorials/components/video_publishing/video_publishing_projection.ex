defmodule VideoTutorials.VideoPublishing.VideoPublishingProjection do
  defstruct [:id, :publishing_attempted?, :source_uri, :transcoded_uri, :owner_id, :sequence, :name]

  def init() do
    %__MODULE__{publishing_attempted?: false, sequence: 0, name: ""}
  end

  def apply(video, %{type: "videoPublished", data: data, global_position: global_position}) do
    %{video | id: data["video_id"], publishing_attempted?: true, owner_id: data["owner_id"], source_uri: data["source_uri"], transcoded_uri: data["transcoded_uri"], sequence: global_position}
  end

  def apply(video, %{type: "videoFailed", data: data, global_position: global_position}) do
    %{video | id: data["video_id"], publishing_attempted?: true, owner_id: data["owner_id"], source_uri: data["source_uri"], transcoded_uri: data["transcoded_uri"], sequence: global_position}
  end

  def apply(video, %{type: "videoNamed", data: data, global_position: global_position}) do
    %{video | name: data["name"], sequence: global_position}
  end

  def apply(video, %{type: "videoNameRejected", data: data, global_position: global_position}) do
    %{video | name: data["name"], sequence: global_position}
  end
end
