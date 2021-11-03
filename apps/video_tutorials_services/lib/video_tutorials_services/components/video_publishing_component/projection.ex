defmodule VideoTutorialsServices.VideoPublishingComponent.Projection do
  use Verity.EntityProjection

  alias VideoTutorialsServices.VideoPublishingComponent.VideoPublishing
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoFailed
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected
  alias VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished

  @impl true
  def init() do
    %VideoPublishing{publishing_attempted?: false, sequence: 0, name: ""}
  end

  @impl true
  def apply(video, %VideoPublished{} = event) do
    %{
      video
      | id: event.video_id,
        publishing_attempted?: true,
        owner_id: event.owner_id,
        source_uri: event.source_uri,
        transcoded_uri: event.transcoded_uri,
        sequence: event.metadata.global_position
    }
  end

  def apply(video, %VideoFailed{} = event) do
    %{
      video
      | id: event.video_id,
        publishing_attempted?: true,
        owner_id: event.owner_id,
        source_uri: event.source_uri,
        transcoded_uri: event.transcoded_uri,
        sequence: event.metadata.global_position
    }
  end

  def apply(video, %VideoNamed{} = event) do
    %{video | name: event.name, sequence: event.metadata.global_position}
  end

  def apply(video, %VideoNameRejected{} = event) do
    %{video | name: event.name, sequence: event.metadata.global_position}
  end
end
