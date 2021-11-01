defmodule VideoTutorialsServices.IdentityComponent.Messages.Commands.Register do
  use Verity.Messaging.Message

  attributes [:user_id, :email, :password_hash]
end
