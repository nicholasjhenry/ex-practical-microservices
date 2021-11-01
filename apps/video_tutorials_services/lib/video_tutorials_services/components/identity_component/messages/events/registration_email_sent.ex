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
end
