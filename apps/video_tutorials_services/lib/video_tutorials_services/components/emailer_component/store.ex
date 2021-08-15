defmodule VideoTutorialsServices.EmailerComponent.Store do
  import Verity.Messaging.StreamName

  alias VideoTutorialsServices.EmailerComponent.Projection

  @category :sendEmail

  def fetch(id) do
    stream_name = stream_name(id, @category)
    MessageStore.fetch(stream_name, Projection)
  end
end
