defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent do
  use Verity.Messaging.Message

  defstruct [:metadata, :user_id, :email_id]
end
