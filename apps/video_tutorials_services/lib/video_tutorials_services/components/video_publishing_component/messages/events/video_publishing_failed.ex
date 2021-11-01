defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed do
  use Verity.Messaging.Message

  defstruct [:metadata, :video_id, :owner_id, :source_uri, :reason]

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
        "reason" => message.reason,
        "videoId" => message.video_id
      },
      # TODO
      expected_version: nil
    )
  end
end
