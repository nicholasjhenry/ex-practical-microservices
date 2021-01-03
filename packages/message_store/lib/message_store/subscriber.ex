defmodule MessageStore.Subscriber do
  defstruct stream_name: nil, version: -1, subscribed_to: nil, current_position: 0, handled_message_result: nil, origin_stream_name: nil

  def start(stream_name, subscribed_to, subscription_message, opts \\ [])

  def start(stream_name, subscribed_to, nil, opts) do
    origin_stream_name = Keyword.get(opts, :origin_stream_name)
    %__MODULE__{stream_name: stream_name, subscribed_to: subscribed_to, origin_stream_name: origin_stream_name}
  end

  def start(stream_name, subscribed_to, subscription_message, opts) do
    position = Map.fetch!(subscription_message.data, "position")
    origin_stream_name = Keyword.get(opts, :origin_stream_name)
    %__MODULE__{stream_name: stream_name, version: subscription_message.position, subscribed_to: subscribed_to, current_position: position, origin_stream_name: origin_stream_name}
  end

  def handle_message(%{subscribed_to: subscribed_to} = subscriber, message, handler) do
    if match?([^subscribed_to | _], String.split(message.stream_name, "-")) do
      updated_subscriber = maybe_call_handler(subscriber, handler, message)
      {:ok, updated_subscriber}
    else
      {:error, :message_from_another_stream}
    end
  end

  defp maybe_call_handler(%{origin_stream_name: nil} = subscriber, handler, message) do
    result = call_handler(handler, message)
    %{subscriber | current_position: message.global_position, handled_message_result: result}
  end

  defp maybe_call_handler(%{origin_stream_name: category} = subscriber, handler, %{metadata: %{"origin_stream_name" => origin_stream_name}} = message) do
    if match?([^category | _], String.split(origin_stream_name, "-")) do
      result = call_handler(handler, message)
      %{subscriber | current_position: message.global_position, handled_message_result: result}
    else
      subscriber
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
