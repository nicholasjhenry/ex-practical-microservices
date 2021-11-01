defmodule VideoTutorialsServices.EmailerComponent.Messages.Commands.Send do
  use Verity.Messaging.Message

  defstruct [:metadata, :to, :subject, :text, :html, :email_id]
end
