defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected do
  alias MessageStore.MessageData

  def follow(message, reason) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoNameRejected",
      metadata: %{
        "traceId" => Map.fetch!(message.metadata, "traceId"),
        "userId" => Map.fetch!(message.metadata, "userId")
      },
      data: %{
        "name" => Map.fetch!(message.data, "name"),
        "reason" => reason
      },
      # TODO
      expected_version: nil
    )
  end
end
