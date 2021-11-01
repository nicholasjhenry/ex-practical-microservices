defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed do
  alias MessageStore.MessageData

  defstruct [:metadata, :video_id, :owner_id, :source_uri, :reason]

  def new(metadata, data) do
    MessageData.Write.new(
      stream_name: nil,
      type: "VideoPublishingFailed",
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
        "reason" => message.reason,
        "videoId" => message.video_id
      },
      # TODO
      expected_version: nil
    )
  end
end
