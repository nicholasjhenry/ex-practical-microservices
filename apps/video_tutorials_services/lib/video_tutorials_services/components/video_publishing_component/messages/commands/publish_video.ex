defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.PublishVideo do
  use Verity.Messaging.Message

  defstruct [:metadata, :video_id, :owner_id, :source_uri]

  def parse(message_data) do
    %__MODULE__{
      metadata: Metadata.from_message_data(message_data),
      owner_id: Map.fetch!(message_data.data, "ownerId"),
      source_uri: Map.fetch!(message_data.data, "sourceUri"),
      video_id: Map.fetch!(message_data.data, "videoId")
    }
  end
end
