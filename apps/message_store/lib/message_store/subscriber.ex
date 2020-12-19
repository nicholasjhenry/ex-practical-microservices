defmodule MessageStore.Subscriber do
  defstruct stream_name: "unknown", current_position: -1, handled_message_result: nil

  def start(stream_name, nil) do
    %__MODULE__{stream_name: stream_name}
  end

  def start(stream_name, subscription_message) do
    %__MODULE__{stream_name: stream_name, current_position: subscription_message.position}
  end

  def handle_message(
    %{current_position: current_position},
    %{position: position},
    _handler) when current_position + 1 != position do
    {:error, :invalid_position}
  end

  def handle_message(%{stream_name: subscriber_stream_name} = subscriber, message, handler) do
    if match?([^subscriber_stream_name, _id], String.split(message.stream_name, "-")) do
      result = handler.handle_message(message)
      updated_subscriber = %{subscriber | current_position: message.position, handled_message_result: result}
      {:ok, updated_subscriber}
    else
      {:error, :message_from_another_stream}
    end
  end

  def handle_messages(subscriber, messages, handler) do
    result =
      messages
      |> Enum.reduce([], fn
          (message, []) ->
            {:ok, updated_subscriber} = handle_message(subscriber, message, handler)
            [updated_subscriber]
          (message, [subscriber | rest]) ->
            {:ok, updated_subscriber} = handle_message(subscriber, message, handler)
            [updated_subscriber | [subscriber | rest]]
      end)

    {:ok, result}
  end
end
