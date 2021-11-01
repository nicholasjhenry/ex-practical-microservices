defmodule VideoTutorialsServices.IdentityComponent.Messages.Commands.Register do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email, :password_hash]

  def parse(message_data) do
    %__MODULE__{
      metadata: Metadata.parse(message_data.metadata),
      user_id: Map.fetch!(message_data.data, "userId"),
      email: Map.fetch!(message_data.data, "email"),
      password_hash: Map.fetch!(message_data.data, "passwordHash")
    }
  end
end
