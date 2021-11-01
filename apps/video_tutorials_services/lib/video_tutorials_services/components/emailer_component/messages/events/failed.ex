defmodule VideoTutorialsServices.EmailerComponent.Messages.Events.Failed do
  use Verity.Messaging.Message

  defstruct [:to, :subject, :text, :html, :email_id, :metadata, :reason]

  def follow(message, attrs \\ %{}) do
    fields = message |> Map.from_struct() |> Map.merge(attrs)
    struct!(__MODULE__, fields)
  end

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "Send",
      metadata: Metadata.to_raw(message.metadata),
      data: %{
        "to" => message.to,
        "subject" => message.subject,
        "text" => message.text,
        "emailId" => message.email_id,
        "html" => message.html,
        "reason" => message.reason
      },
      expected_version: nil
    )
  end
end
