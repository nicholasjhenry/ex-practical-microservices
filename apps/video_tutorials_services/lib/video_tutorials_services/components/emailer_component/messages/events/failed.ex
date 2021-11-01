defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Failed do
  use Verity.Messaging.Message

  defstruct [:metadata, :to, :subject, :text, :html, :email_id, :reason]
end
