defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.Registered do
  use Verity.Messaging.Message

  attributes [:user_id, :email, :password_hash]
end
