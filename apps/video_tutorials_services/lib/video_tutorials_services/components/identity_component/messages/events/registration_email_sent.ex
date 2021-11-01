defmodule VideoTutorialsServices.IdentityComponent.Messages.Events.RegistrationEmailSent do
  use Verity.Messaging.Message

  attributes [:user_id, :email_id]
end
