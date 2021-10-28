defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.Registered do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email, :password_hash]

  def follow(message, attrs \\ %{}) do
    fields = message |> Map.from_struct() |> Map.merge(attrs)
    struct!(__MODULE__, fields)
  end

  def parse(message_data) do
    %__MODULE__{
      metadata: Metadata.parse(message_data.metadata),
      user_id: Map.fetch!(message_data.data, "userId"),
      email: Map.fetch!(message_data.data, "email"),
      password_hash: Map.fetch!(message_data.data, "passwordHash")
    }
  end

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Registered",
      metadata: Metadata.to_raw(message.metadata),
      data: %{
        "userId" => message.user_id,
        "email" => message.email,
        "passwordHash" => message.password_hash
      },
      expected_version: nil
    )
  end
end
