defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished do
  use Verity.Messaging.Message

  defstruct [:metadata, :owner_id, :source_uri, :transcoded_uri, :video_id]

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoPublished",
      metadata: metadata,
      data: data,
      # TODO
      expected_version: nil
    )
  end

  def follow(message, attrs \\ %{}) do
    fields = message |> Map.from_struct() |> Map.merge(attrs)
    struct!(__MODULE__, fields)
  end

  def to_message_data(message) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoPublished",
      metadata: %{
        "traceId" => message.metadata.trace_id,
        "userId" => message.metadata.user_id
      },
      data: %{
        "ownerId" => message.owner_id,
        "sourceUri" => message.source_uri,
        "transcodedUri" => message.transcoded_uri,
        "videoId" => message.video_id
      },
      # TODO
      expected_version: nil
    )
  end
end
