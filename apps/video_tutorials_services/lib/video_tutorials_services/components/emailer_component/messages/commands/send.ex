defmodule VideoTutorialsServices.EmailerComponent.Messages.Commands.Send do
  use Verity.Messaging.Message

  attributes [:to, :subject, :text, :html, :email_id]
end
