defmodule VideoTutorials.VideoPublishing.VideoPublishingProjection do
  defstruct [:id, :publishing_attempted?, :source_uri, :transcoded_uri, :owner_id]

  def init() do
    %__MODULE__{publishing_attempted?: false}
  end

  def apply(video, %{type: "videoPublished", data: data}) do
    %{video | id: data["video_id"], publishing_attempted?: true, owner_id: data["owner_id"], source_uri: data["source_uri"], transcoded_uri: data["transcoded_uri"]}
  end

  def apply(video, %{type: "videoFailed", data: data}) do
    %{video | id: data["video_id"], publishing_attempted?: true, owner_id: data["owner_id"], source_uri: data["source_uri"], transcoded_uri: data["transcoded_uri"]}
  end
end
