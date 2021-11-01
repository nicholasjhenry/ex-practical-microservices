defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Failed do
  use Verity.Messaging.Message

  defstruct [:to, :subject, :text, :html, :email_id, :metadata, :reason]
end
