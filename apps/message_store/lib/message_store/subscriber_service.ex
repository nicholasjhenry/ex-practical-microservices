defmodule MessageStore.SubscriberService do
  alias MessageStore.Subscriber

  def start(stream_name) do
    subscriber = Subscriber.start(stream_name, nil)
    {:ok, subscriber}
  end
end
