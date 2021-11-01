defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected do
  use Verity.Messaging.Message

  defstruct [:metadata, :name, :reason]

  def build(metadata, attrs) do
    struct(__MODULE__, attrs) |> Map.put(:metadata, metadata)
  end

  def follow(message, attrs \\ %{}) do
    fields = message |> Map.from_struct() |> Map.merge(attrs)
    struct!(__MODULE__, fields)
  end

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
