defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Sent do
  use Verity.Messaging.Message
  defstruct [:to, :subject, :text, :html, :email_id, :metadata]

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
