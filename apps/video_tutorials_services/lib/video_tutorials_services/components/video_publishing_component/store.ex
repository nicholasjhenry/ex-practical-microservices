defmodule VideoTutorialsServices.VideoPublishingComponent.Store do
  import Verity.Messaging.StreamName

  alias VideoTutorialsServices.VideoPublishingComponent.Projection

  @category :videoPublishing

  def fetch(id) do
    stream_name = stream_name(id, @category)
    MessageStore.fetch(stream_name, Projection)
  end
end
