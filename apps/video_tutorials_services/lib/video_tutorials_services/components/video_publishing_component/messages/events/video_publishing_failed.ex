defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed do
  alias MessageStore.MessageData

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "videoPublishingFailed",
      metadata: metadata,
      data: data,
      # TODO
      expected_version: nil
    )
  end
end
