defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Sent do
  use Verity.Messaging.Message

  defstruct [:metadata, :to, :subject, :text, :html, :email_id]
end
