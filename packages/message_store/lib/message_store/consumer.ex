defmodule MessageStore.Consumer do
  defstruct stream_name: nil,
            version: -1,
            subscribed_to: nil,
            current_position: 0,
            handled_message_result: nil,
            origin_stream_name: nil,
            filter: nil

  def start(stream_name, subscribed_to, subscription_message, opts \\ [])

  def start(stream_name, subscribed_to, nil, opts) do
    origin_stream_name = Keyword.get(opts, :origin_stream_name)
    filter = Keyword.get(opts, :filter)

    %__MODULE__{
      stream_name: stream_name,
      subscribed_to: subscribed_to,
      origin_stream_name: origin_stream_name,
      filter: filter
    }
  end

  def start(stream_name, subscribed_to, subscription_message, opts) do
    position = Map.fetch!(subscription_message.data, "position")
    origin_stream_name = Keyword.get(opts, :origin_stream_name)
    filter = Keyword.get(opts, :filter)

    %__MODULE__{
      stream_name: stream_name,
      version: subscription_message.position,
      subscribed_to: subscribed_to,
      current_position: position,
      origin_stream_name: origin_stream_name,
      filter: filter
    }
  end

  def handle_message(%{subscribed_to: subscribed_to} = subscriber, message, handlers) do
    handlers = List.wrap(handlers)

    if subscribed_to == "$all" ||
         match?([^subscribed_to | _], String.split(message.stream_name, "-")) do
      updated_subscriber = maybe_call_handlers(subscriber, handlers, message)
      {:ok, updated_subscriber}
    else
      {:error, :message_from_another_stream}
    end
  end

  defp maybe_call_handlers(%{origin_stream_name: nil} = subscriber, handlers, message) do
    results = Enum.map(handlers, &call_handler(&1, message))
    %{subscriber | current_position: message.global_position, handled_message_result: results}
  end

  defp maybe_call_handlers(
         %{origin_stream_name: category} = subscriber,
         handlers,
         %{metadata: %{"originStreamName" => origin_stream_name}} = message
       ) do
    if match?([^category | _], String.split(origin_stream_name, "-")) do
      results = Enum.map(handlers, &call_handler(&1, message))
      %{subscriber | current_position: message.global_position, handled_message_result: results}
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
