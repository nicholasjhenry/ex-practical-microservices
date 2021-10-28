defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Sent do
  use Verity.Messaging.Message
  defstruct [:to, :subject, :text, :html, :email_id, :metadata]

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Sent",
      metadata: metadata,
      data: data
    )
  end

  def follow(message) do
    struct!(__MODULE__, Map.from_struct(message))
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
      type: "Sent",
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
