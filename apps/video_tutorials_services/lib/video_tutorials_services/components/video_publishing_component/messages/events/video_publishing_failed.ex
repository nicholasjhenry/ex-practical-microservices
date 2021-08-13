defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed do
  alias MessageStore.NewMessage

  def new(metadata, data) do
    NewMessage.new(
      stream_name: nil,
      type: "videoPublishingFailed",
      metadata: metadata,
      data: data,
      # TODO
      expected_version: nil
    )
  end
end
