defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Failed do
  use Verity.Messaging.Message

  attributes [:to, :subject, :text, :html, :email_id, :reason]
end
