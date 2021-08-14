defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Failed do
  alias MessageStore.NewMessage

  def new(metadata, data) do
    NewMessage.new(
      stream_name: nil,
      type: "Failed",
      metadata: metadata,
      data: data
    )
  end
end
