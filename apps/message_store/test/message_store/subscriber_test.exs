defmodule MessageStore.SubscriberTest do
  use ExUnit.Case

  alias MessageStore.Subscriber

  describe "starting a subscriber" do
    test "given no subscription message starts at the position 0" do
      subscription_message = nil
      subject = Subscriber.start(subscription_message)
      assert subject.next_position == 0
    end

    test "give a subscription message starts at the recorded position" do
      subscription_message = %{position: 10}
      subject = Subscriber.start(subscription_message)
      assert subject.next_position == 11
    end
  end

  describe "handling messages" do
    test "invokes the handler and records the new position" do
      message = %{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        position: 0,
        global_position: 0,
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{}
      }

      subscriber = Subscriber.start(nil)
      handler = fn handled_message -> String.upcase(handled_message.type) end
      subject = Subscriber.handle_message(subscriber, message, handler)

      assert subject.next_position == 1
      assert subject.handled_message_result == "VIDEOCREATED"
    end
  end
end
