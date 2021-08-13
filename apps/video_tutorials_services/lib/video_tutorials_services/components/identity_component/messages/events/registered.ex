defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.Registered do
  alias MessageStore.NewMessage

  def follow(message) do
    NewMessage.new(
      stream_name: nil,
      type: "Registered",
      metadata: %{
        trace_id: Map.fetch!(message.metadata, "trace_id"),
        user_id: Map.fetch!(message.metadata, "user_id")
      },
      data: %{
        user_id: Map.fetch!(message.data, "user_id"),
        email: Map.fetch!(message.data, "email"),
        password_hash: Map.fetch!(message.data, "password_hash")
      }
    )
  end
end
