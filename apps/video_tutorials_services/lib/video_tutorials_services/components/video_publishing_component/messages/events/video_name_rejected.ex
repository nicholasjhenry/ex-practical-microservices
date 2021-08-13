defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected do
  alias MessageStore.NewMessage

  def follow(message, reason) do
    NewMessage.new(
      stream_name: nil,
      type: "VideoNameRejected",
      metadata: %{
        trace_id: Map.fetch!(message.metadata, "trace_id"),
        user_id: Map.fetch!(message.metadata, "user_id")
      },
      data: %{
        name: Map.fetch!(message.data, "name"),
        reason: reason
      },
      # TODO
      expected_version: nil
    )
  end
end
