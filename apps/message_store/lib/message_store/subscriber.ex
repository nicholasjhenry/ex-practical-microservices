defmodule MessageStore.Subscriber do
  defstruct stream_name: "unknown", next_position: 0, handled_message_result: nil

  def start(stream_name, nil) do
    %__MODULE__{stream_name: stream_name}
  end

  def start(stream_name, subscription_message) do
    %__MODULE__{stream_name: stream_name, next_position: subscription_message.position + 1}
  end

  def handle_message(%{stream_name: subscriber_stream_name} = subscriber, message, handler) do
    if match?([^subscriber_stream_name, _id], String.split(message.stream_name, "-")) do
      result = handler.(message)
      updated_subscriber = %{subscriber | next_position: subscriber.next_position + 1, handled_message_result: result}
      {:ok, updated_subscriber}
    else
      {:error, :message_from_another_stream}
    end
  end
end
