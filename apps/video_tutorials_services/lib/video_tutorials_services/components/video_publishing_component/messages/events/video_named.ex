defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed do
  alias MessageStore.MessageData

  def follow(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoNamed",
      metadata: %{
        "traceId" => Map.fetch!(message.metadata, "traceId"),
        "userId" => Map.fetch!(message.metadata, "userId")
      },
      data: %{
        "name" => Map.fetch!(message.data, "name")
      },
      # TODO
      expected_version: nil
    )
  end
end
