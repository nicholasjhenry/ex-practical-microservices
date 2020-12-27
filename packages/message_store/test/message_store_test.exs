defmodule MessageStoreTest do
  use ExUnit.Case

  alias MessageStore.{NewMessage, Repo, VersionConflictError}

  setup do
    Repo.truncate_messages()
    start_supervised!(MessageStore.Repo)

    :ok
  end

  describe "writing a message to a stream" do
    test "can get the messages written to the stream" do
      message = %NewMessage{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{},
        expected_version: -1
      }

      MessageStore.write_message(message)
      assert [message] = MessageStore.get_stream_messages("video-1")
      assert message.id == "5e731bdc-07aa-430a-8aae-543b45dd7235"
    end

    test "handles version conflicts" do
      message = %NewMessage{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{},
        expected_version: 0
      }

      assert_raise VersionConflictError, "Wrong expected version: 0 (Stream: video-1, Stream Version: -1)", fn ->
        MessageStore.write_message(message)
      end
    end
  end

  describe "reading the last message of a stream" do
    test "given a message exists for the stream returns the last message" do
      message = %NewMessage{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{},
        expected_version: -1
      }

      MessageStore.write_message(message)

      assert message = MessageStore.read_last_message("video-1")
      assert message.id == "5e731bdc-07aa-430a-8aae-543b45dd7235"
    end

    test "given no message exists for the stream returns the last message" do
      message = MessageStore.read_last_message("video-1")
      assert is_nil(message)
    end
  end

  describe "getting messages from a category" do
    test "given a message exists for the stream returns the last message" do
      message = %NewMessage{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"},
        metadata: %{},
        expected_version: -1
      }

      MessageStore.write_message(message)

      assert [message] = MessageStore.get_category_messages("video", 0)
      assert message.id == "5e731bdc-07aa-430a-8aae-543b45dd7235"
    end

    test "given no message exists for the stream returns the last message" do
      message = MessageStore.read_last_message("video-1")
      assert is_nil(message)
    end
  end
end
