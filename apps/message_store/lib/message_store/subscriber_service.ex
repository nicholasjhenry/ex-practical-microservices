defmodule MessageStore.SubscriberService do
  alias MessageStore.Subscriber

  def start(subscriber_name, stream_name) do
    message = MessageStore.read_last_message(subscriber_name)
    subscriber = Subscriber.start(stream_name, message)
    {:ok, subscriber}
  end
end
