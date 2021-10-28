defmodule VideoTutorialsServices.EmailerComponent.Messages.Commands.Send do
  use Verity.Messaging.Message

  alias MessageStore.MessageData

  # http://docs.eventide-project.org/user-guide/messages-and-message-data/metadata.html#metadata-attributes

  defstruct [:to, :subject, :text, :html, :email_id, :metadata]

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Send",
      metadata: metadata,
      data: data,
      # TODO: review expected version
      expected_version: nil
    )
  end

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

  def to_message_data(command) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Send",
      metadata: Metadata.to_raw(command.metadata),
      data: %{
        "to" => command.to,
        "subject" => command.subject,
        "text" => command.text,
        "emailId" => command.email_id,
        "html" => command.html
      },
      expected_version: nil
    )
  end
end
