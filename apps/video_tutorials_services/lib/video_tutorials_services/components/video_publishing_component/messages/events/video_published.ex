defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished do
  alias MessageStore.MessageData

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoPublished",
      metadata: metadata,
      data: data,
      # TODO
      expected_version: nil
    )
  end
end
