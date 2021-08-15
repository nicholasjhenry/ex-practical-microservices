defmodule VideoTutorialsServices.IdentityComponent.Store do
  import Verity.Messaging.StreamName

  alias VideoTutorialsServices.IdentityComponent.Projection

  @category :identity

  def fetch(id) do
    stream_name = stream_name(id, @category)
    MessageStore.fetch(stream_name, Projection)
  end
end
