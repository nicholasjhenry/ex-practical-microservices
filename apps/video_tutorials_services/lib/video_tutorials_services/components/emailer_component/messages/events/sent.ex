defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Sent do
  alias MessageStore.NewMessage

  def new(metadata, data) do
    NewMessage.new(
      stream_name: nil,
      type: "Sent",
      metadata: metadata,
      data: data
    )
  end
end
