defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Sent do
  use Verity.Messaging.Message

  attributes [:to, :subject, :text, :html, :email_id]
end
