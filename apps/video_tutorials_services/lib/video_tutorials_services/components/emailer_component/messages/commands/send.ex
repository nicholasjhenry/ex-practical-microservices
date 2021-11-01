defmodule VideoTutorialsServices.EmailerComponent.Messages.Commands.Send do
  use Verity.Messaging.Message

  defstruct [:metadata, :to, :subject, :text, :html, :email_id]

  def parse(message_data) do
    %__MODULE__{
      metadata: Metadata.parse(message_data.metadata),
      to: Map.fetch!(message_data.data, "to"),
      email_id: Map.fetch!(message_data.data, "emailId"),
      subject: Map.fetch!(message_data.data, "subject"),
      text: Map.fetch!(message_data.data, "text"),
      html: Map.fetch!(message_data.data, "html")
    }
  end
end
