defmodule VideoTutorialsServices.IdentityComponent.Store do
  alias VideoTutorialsServices.IdentityComponent.Projection

  def fetch(id) do
    MessageStore.fetch("identity-#{id}", Projection)
  end
end
