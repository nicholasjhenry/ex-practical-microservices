defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.NameVideo do
  use Verity.Messaging.Message

  defstruct [:metadata, :video_id, :name]

  def parse(message_data) do
    %__MODULE__{
      metadata: Metadata.from_message_data(message_data),
      video_id: Map.fetch!(message_data.data, "videoId"),
      name: Map.fetch!(message_data.data, "name")
    }
  end

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "NameVideo",
      metadata: Metadata.to_raw(message.metadata),
      data: %{
        "videoId" => message.video_id,
        "name" => message.name
      },
      expected_version: nil
    )
  end
end
