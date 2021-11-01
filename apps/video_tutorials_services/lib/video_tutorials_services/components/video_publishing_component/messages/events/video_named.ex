defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed do
  use Verity.Messaging.Message

  defstruct [:metadata, :name]

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
