defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed do
  alias MessageStore.MessageData

  def follow(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoNamed",
      metadata: %{
        trace_id: Map.fetch!(message.metadata, "trace_id"),
        user_id: Map.fetch!(message.metadata, "user_id")
      },
      data: %{
        name: Map.fetch!(message.data, "name")
      },
      # TODO
      expected_version: nil
    )
  end
end
