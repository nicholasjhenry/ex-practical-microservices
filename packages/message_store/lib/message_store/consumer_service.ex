defmodule MessageStore.ConsumerService do
  alias MessageStore.{MessageData, Consumer}

  def start(stream_name, subscribed_to, opts \\ []) do
    message = MessageStore.read_last_message(stream_name)
    subscriber = Consumer.start(stream_name, subscribed_to, message, opts)
    {:ok, subscriber}
  end

  require Logger

  def run(subscriber, handler) do
    messages =
      MessageStore.get_category_messages(
        subscriber.subscribed_to,
        subscriber.current_position + 1
      )
      |> filter(subscriber.filter)

    Logger.debug(inspect(subscriber) <> "\n" <> inspect(messages))

    case messages do
      [] ->
        subscriber

      _ ->
        {:ok, [updated_subscriber | _]} = Consumer.handle_messages(subscriber, messages, handler)

        # TODO: improve testing
        if updated_subscriber.current_position == subscriber.current_position do
          subscriber
        else
          message =
            MessageData.Write.new(
              stream_name: updated_subscriber.stream_name,
              type: "Read",
              data: %{position: updated_subscriber.current_position},
              expected_version: updated_subscriber.version
            )

          MessageStore.write_message(message)

          %{updated_subscriber | version: subscriber.version + 1}
        end
    end
  end

  # TODO Testing
  defp filter(messages, nil), do: messages

  defp filter(messages, prefix) do
    Enum.filter(messages, &String.starts_with?(&1.stream_name, prefix))
  end
end
