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
end
