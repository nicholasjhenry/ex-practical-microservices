defmodule MessageStore.Subscriber do
  defstruct stream_name: nil, version: -1, subscribed_to: nil, current_position: 0, handled_message_result: nil

  def start(stream_name,subscribed_to, nil) do
    %__MODULE__{stream_name: stream_name, subscribed_to: subscribed_to}
  end

  def start(stream_name, subscribed_to, subscription_message) do
    position = Map.fetch!(subscription_message.data, "position")
    %__MODULE__{stream_name: stream_name, version: subscription_message.position, subscribed_to: subscribed_to, current_position: position}
  end

  def handle_message(%{subscribed_to: subscribed_to} = subscriber, message, handler) do
    if match?([^subscribed_to | _], String.split(message.stream_name, "-")) do
      result = call_handler(handler, message)
      updated_subscriber = %{subscriber | current_position: message.global_position, handled_message_result: result}
      {:ok, updated_subscriber}
    else
      {:error, :message_from_another_stream}
    end
  end

  defp call_handler(handler, message) when is_atom(handler) do
    handler.handle_message(message)
  end

  defp call_handler(handler, message) when is_function(handler) do
    handler.(message)
  end

  def handle_messages(subscriber, messages, handler) do
    result = Enum.reduce(messages, [], &next_message(subscriber, handler, &1, &2))
    {:ok, result}
  end

  defp next_message(subscriber, handler, message, []) do
    {:ok, updated_subscriber} = handle_message(subscriber, message, handler)
    [updated_subscriber]
  end

  defp next_message(_subscriber, handler, message, [latest_subscriber | rest]) do
    {:ok, updated_subscriber} = handle_message(latest_subscriber, message, handler)
    [updated_subscriber | [latest_subscriber | rest]]
  end
end
