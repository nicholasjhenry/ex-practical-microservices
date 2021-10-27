defmodule VideoTutorialsServices.VideoPublishingComponent.Store do
  alias VideoTutorialsServices.VideoPublishingComponent.Projection
  # alias VideoTutorialsServices.VideoPublishingComponent.VideoPublishing

  use Verity.EntityStore,
    category: :videoPublishing,
    entity: VideoPublishing,
    projection: Projection
end
