defmodule MessageStore.SubscriberService do
  alias MessageStore.Subscriber

  def start(stream_name, subscribed_to) do
    message = MessageStore.read_last_message(stream_name)
    subscriber = Subscriber.start(stream_name, subscribed_to, message)
    {:ok, subscriber}
  end

  def run(subscriber, handler) do
    messages = MessageStore.get_category_messages(subscriber.subscribed_to, subscriber.current_position + 1)
    case messages do
      [] -> subscriber
      _ ->
      {:ok, [subscriber | _]} = Subscriber.handle_messages(subscriber, messages, handler)

      message = %{
        id: UUID.uuid4(),
        stream_name: subscriber.stream_name,
        type: "Read",
        data: %{position: subscriber.current_position},
        metadata: %{},
        expected_version: subscriber.version
      }
      MessageStore.write_message(message)

      %{subscriber | version: subscriber.version + 1}
    end
  end
end
