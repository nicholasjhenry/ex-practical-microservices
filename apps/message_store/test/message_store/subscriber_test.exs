defmodule MessageStore.SubscriberTest do
  use ExUnit.Case

  alias MessageStore.Subscriber

  describe "starting a subscriber" do
    test "given no subscription message starts at the position 0" do
      subscription_message = nil
      subject = Subscriber.start("new_stream", subscription_message)
      assert subject.next_position == 0
    end

    test "give a subscription message starts at the recorded position" do
      subscription_message = %{position: 10}
      subject = Subscriber.start("new_stream", subscription_message)
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

      subscriber = Subscriber.start("video", nil)
      handler = fn handled_message -> String.upcase(handled_message.type) end
      {:ok, subject} = Subscriber.handle_message(subscriber, message, handler)

      assert subject.next_position == 1
      assert subject.handled_message_result == "VIDEOCREATED"
    end

    test "given a message from another stream returns an error " do
      message = %{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        position: 0,
        global_position: 0,
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{}
      }

      subscriber = Subscriber.start("comment", nil)
      subject = Subscriber.handle_message(subscriber, message, fn(_) -> :foo end)

      assert {:error, :message_from_another_stream} = subject
    end

    test "given a different position returns an error" do
      message = %{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        position: 0,
        global_position: 0,
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{}
      }

      subscriber = Subscriber.start("video", message)
      subject = Subscriber.handle_message(subscriber, %{message | position: 4}, fn(_) -> :foo end)

      assert {:error, :invalid_position} = subject
    end
  end
end
