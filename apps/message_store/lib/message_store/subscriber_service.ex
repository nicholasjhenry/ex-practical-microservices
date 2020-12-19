defmodule MessageStore.SubscriberService do
  alias MessageStore.Subscriber

  def start(stream_name, subscribed_to) do
    message = MessageStore.read_last_message(stream_name)
    subscriber = Subscriber.start(stream_name, subscribed_to, message)
    {:ok, subscriber}
  end

  def run(subscriber, position, handler) do
      message = %{
        id: UUID.uuid4(),
        stream_name: subscriber.stream_name,
        type: "Read",
        data: %{position: 1},
        metadata: %{},
        expected_version: subscriber.current_position
      }

      messages = MessageStore.get_category_messages(subscriber.subscribed_to, position)
      {:ok, [subscriber | _]} = Subscriber.handle_messages(subscriber, messages, handler)

      MessageStore.write_message(message)

      subscriber
  end
end
