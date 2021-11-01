defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email_id]

  def build(metadata, attrs) do
    struct(__MODULE__, attrs) |> Map.put(:metadata, metadata)
  end

  def follow(message, attrs \\ %{}, meta \\ %{}) do
    fields = message |> Map.from_struct() |> Map.merge(attrs)
    new_message = struct!(__MODULE__, fields)
    %{new_message | metadata: Map.merge(message.metadata, meta)}
  end

  def parse(message_data) do
    %__MODULE__{
      metadata: Metadata.parse(message_data.metadata),
      user_id: Map.fetch!(message_data.data, "userId"),
      email_id: Map.fetch!(message_data.data, "emailId")
    }
  end

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "RegistrationEmailSent",
      metadata: %{
        "traceId" => message.metadata.trace_id,
        "userId" => message.metadata.user_id
      },
      data: %{
        "emailId" => message.email_id,
        "userId" => message.user_id
      },
      # TODO
      expected_version: nil
    )
  end
end
