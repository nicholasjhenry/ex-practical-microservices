defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email_id]

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
