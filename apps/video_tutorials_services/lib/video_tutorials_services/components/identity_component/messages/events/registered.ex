defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.Registered do
  alias MessageStore.MessageData

  def follow(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Registered",
      metadata: %{
        "traceId" => Map.fetch!(message.metadata, "traceId"),
        "userId" => Map.fetch!(message.metadata, "userId")
      },
      data: %{
        "userId" => Map.fetch!(message.data, "userId"),
        "email" => Map.fetch!(message.data, "email"),
        "passwordHash" => Map.fetch!(message.data, "passwordHash")
      }
    )
  end
end
