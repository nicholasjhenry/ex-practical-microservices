defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected do
  use Verity.Messaging.Message

  defstruct [:metadata, :name, :reason]

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoNameRejected",
      metadata: Metadata.to_raw(message.metadata),
      data: %{
        "name" => message.name,
        "reason" => message.reason
      },
      # TODO
      expected_version: nil
    )
  end
end
