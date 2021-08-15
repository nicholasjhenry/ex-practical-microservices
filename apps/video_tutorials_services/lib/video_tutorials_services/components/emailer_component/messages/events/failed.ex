defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Failed do
  alias MessageStore.MessageData

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Failed",
      metadata: metadata,
      data: data
    )
  end
end
