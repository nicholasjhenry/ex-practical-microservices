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
    if match?([^subscribed_to, _id], String.split(message.stream_name, "-")) do
      result = call_handler(handler, message)
      updated_subscriber = %{subscriber | current_position: message.global_position, handled_message_result: result}
      {:ok, updated_subscriber}
    else
      {:error, :message_from_another_stream}
    end
  end

  def call_handler(handler, message) when is_atom(handler) do
    handler.handle_message(message)
  end

  def call_handler(handler, message) when is_function(handler) do
    handler.(message)
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
