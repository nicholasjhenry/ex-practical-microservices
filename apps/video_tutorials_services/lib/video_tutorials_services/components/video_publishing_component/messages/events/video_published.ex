defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished do
  alias MessageStore.NewMessage

  def new(metadata, data) do
    NewMessage.new(
      stream_name: nil,
      type: "videoPublished",
      metadata: metadata,
      data: data,
      # TODO
      expected_version: nil
    )
  end
end
