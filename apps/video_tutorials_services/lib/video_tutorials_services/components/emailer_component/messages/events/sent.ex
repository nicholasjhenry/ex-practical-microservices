defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Sent do
  alias MessageStore.MessageData

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Sent",
      metadata: metadata,
      data: data
    )
  end
end
