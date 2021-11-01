defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.Registered do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email, :password_hash]
end
