defmodule MessageStore.SubscriberService do
  alias MessageStore.{NewMessage, Subscriber}

  def start(stream_name, subscribed_to, opts \\ []) do
    message = MessageStore.read_last_message(stream_name)
    subscriber = Subscriber.start(stream_name, subscribed_to, message, opts)
    {:ok, subscriber}
  end

  def run(subscriber, handler) do
    messages = MessageStore.get_category_messages(subscriber.subscribed_to, subscriber.current_position + 1)
    case messages do
      [] -> subscriber
      _ ->
      {:ok, [updated_subscriber | _]} = Subscriber.handle_messages(subscriber, messages, handler)

      # TODO: improve testing
      if updated_subscriber.current_position == subscriber.current_position do
        subscriber
      else
        message = NewMessage.new(
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
end
