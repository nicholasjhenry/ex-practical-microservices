defmodule MessageStore.ConsumerServiceTest do
  use ExUnit.Case

  alias MessageStore.{MessageData, Repo, ConsumerService}

  setup do
    start_supervised!(MessageStore.Repo)
    Repo.truncate_messages()

    :ok
  end

  describe "starting" do
    test "given no existing state" do
      {:ok, subscriber} = ConsumerService.start("subscriber-foo", "video")
      assert subscriber.current_position == 0
    end

    test "given existing state" do
      message =
        MessageData.Write.new(
          stream_name: "subscriber-foo",
          type: "Read",
          data: %{position: 1}
        )

      MessageStore.write_message(message)

      {:ok, subscriber} = ConsumerService.start("subscriber-foo", "video")
      assert subscriber.current_position == 1
    end
  end

  defmodule MessageHandler do
    def handle_message(message) do
      String.upcase(message.data["name"])
    end
  end

  describe "running" do
    test "processes messages for a stream" do
      {:ok, subscriber} = ConsumerService.start("subscriber-foo", "video")

      message =
        MessageData.Write.new(
          stream_name: "video-1",
          type: "VideoCreated",
          data: %{name: "YouTube Video"}
        )

      MessageStore.write_message(message)

      subscriber = ConsumerService.run(subscriber, MessageHandler)
      message = MessageStore.read_last_message("subscriber-foo")
      assert subscriber.current_position == 1
      assert subscriber.handled_message_result == "YOUTUBE VIDEO"
      assert message.data == %{"position" => 1}
    end
  end
end
