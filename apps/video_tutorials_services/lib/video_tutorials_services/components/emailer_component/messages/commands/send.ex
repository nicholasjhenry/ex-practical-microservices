defmodule VideoTutorialsServices.EmailerComponent.Messages.Commands.Send do
  alias MessageStore.MessageData

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Send",
      metadata: metadata,
      data: data,
      # TODO: review expected version
      expected_version: nil
    )
  end
end
