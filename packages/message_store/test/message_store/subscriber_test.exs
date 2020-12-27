defmodule MessageStore.SubscriberTest do
  use ExUnit.Case

  alias MessageStore.{Message, Subscriber}

  def build_message(attrs) do
    defaults = [
      id: UUID.uuid4(),
      position: 0,
      global_position: 0,
      type: "VideoCreated",
      data: %{name: "YouTube Video"},
      metadata: %{}
    ]

    attrs = Keyword.merge(defaults, attrs)
    Message.new(attrs)
  end

  describe "starting a subscriber" do
    test "given no subscription message starts at the position 0" do
      subscription_message = nil
      subject = Subscriber.start("subscriber-foo", "new_stream", subscription_message)
      assert subject.stream_name == "subscriber-foo"
      assert subject.current_position == -0
    end

    test "give a subscription message starts at the recorded position" do
      subscription_message = %{position: 0, data: %{"position" => 10}}
      subject = Subscriber.start("subscriber-foo", "new_stream", subscription_message)
      assert subject.current_position == 10
    end
  end

  defmodule MessageHandler do
    def handle_message(%{type: "VideoCreated"} = message) do
      String.upcase(message.data.name)
    end

    def handle_message(%{type: "VideoUpdated"} = message) do
      String.downcase(message.data.name)
    end
  end

  describe "handling a message" do
    test "invokes the handler and records the new position" do
      message = build_message(
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"}
      )

      subscriber = Subscriber.start("subscriber-foo", "video", nil)
      {:ok, subject} = Subscriber.handle_message(subscriber, message, MessageHandler)

      assert subject.current_position == 0
      assert subject.handled_message_result == "YOUTUBE VIDEO"
    end

    test "given a message from another stream returns an error " do
      message = build_message(
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"}
      )

      subscriber = Subscriber.start("subscriber-foo", "comment", nil)
      subject = Subscriber.handle_message(subscriber, message, MessageHandler)

      assert {:error, :message_from_another_stream} = subject
    end
  end

  describe "handling a batch of messages" do
    test "invokes the handler and records the new position" do
      messages = [
        build_message(
          stream_name: "video-1",
          type: "VideoCreated",
          data: %{name: "YouTube Video"}
        ),
        build_message(
          stream_name: "video-1",
          position: 1,
          global_position: 1,
          type: "VideoUpdated",
          data: %{name: "Vimeo Video"}
        )
      ]

      subscriber = Subscriber.start("subscriber-foo", "video", nil)
      {:ok, [subject| _subject]} = Subscriber.handle_messages(subscriber, messages, MessageHandler)

      assert subject.current_position == 1
      assert subject.handled_message_result == "vimeo video"
    end
  end
end
