defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed do
  use Verity.Messaging.Message

  defstruct [:metadata, :name]

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoNamed",
      metadata: %{
        "traceId" => message.metadata.trace_id,
        "userId" => message.metadata.user_id
      },
      data: %{
        "name" => message.name
      },
      # TODO
      expected_version: nil
    )
  end
end
