defmodule VideoTutorialsServices.IdentityComponent.Messages.Commands.Register do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email, :password_hash]
end
