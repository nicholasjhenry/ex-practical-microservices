defmodule VideoTutorialsServices.IdentityComponent.Store do
  alias VideoTutorialsServices.IdentityComponent.Projection
  # alias VideoTutorialsServices.VideoPublishingComponent.Identity

  use Verity.EntityStore,
    category: :identity,
    entity: Identity,
    projection: Projection
end
