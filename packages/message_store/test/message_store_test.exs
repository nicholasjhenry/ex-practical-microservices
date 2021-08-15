defmodule MessageStoreTest do
  use ExUnit.Case

  alias MessageStore.{MessageData, Repo, VersionConflictError}

  setup do
    start_supervised!(MessageStore.Repo)
    Repo.truncate_messages()

    :ok
  end

  def build_new_message(attrs) do
    defaults = [type: "VideoCreated", data: %{name: "YouTube Video"}]
    attrs = Keyword.merge(defaults, attrs)
    MessageData.Write.new(attrs)
  end

  describe "writing a message to a stream" do
    test "can get the messages written to the stream" do
      message =
        build_new_message(
          id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
          stream_name: "video-1"
        )

      MessageStore.write_message(message)

      assert [message] = MessageStore.get_stream_messages("video-1")
      assert message.id == "5e731bdc-07aa-430a-8aae-543b45dd7235"
    end

    test "handles version conflicts" do
      message = build_new_message(stream_name: "video-1", expected_version: 0)

      assert_raise VersionConflictError,
                   "Wrong expected version: 0 (Stream: video-1, Stream Version: -1)",
                   fn ->
                     MessageStore.write_message(message)
                   end
    end

    test "ignores unspecified expected version" do
      message = build_new_message(stream_name: "video-1", expected_version: nil)

      MessageStore.write_message(message)
    end
  end

  describe "reading the last message of a stream" do
    test "given a message exists for the stream returns the last message" do
      message =
        build_new_message(
          id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
          stream_name: "video-1"
        )

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
      message =
        build_new_message(
          id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
          stream_name: "video-1"
        )

      MessageStore.write_message(message)

      assert [message] = MessageStore.get_category_messages("video", 0)
      assert message.id == "5e731bdc-07aa-430a-8aae-543b45dd7235"
    end

    test "given no message exists for the stream returns the last message" do
      message = MessageStore.read_last_message("video-1")
      assert is_nil(message)
    end
  end

  describe "getting all messages" do
    test "given a message exists the last message" do
      message =
        build_new_message(
          id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
          stream_name: "video-1"
        )

      MessageStore.write_message(message)

      assert [message] = MessageStore.get_category_messages("$all", 0)
      assert message.id == "5e731bdc-07aa-430a-8aae-543b45dd7235"
    end
  end

  defmodule FakeProjection do
    defstruct [:id, :name]

    def init() do
      %__MODULE__{}
    end

    def apply(entity, %{type: "VideoCreated", data: data}) do
      %{entity | id: data["id"], name: data["name"]}
    end

    def apply(entity, %{type: "VideoTitleUpcased"}) do
      %{entity | name: String.upcase(entity.name)}
    end
  end

  describe "fetching the stream" do
    test "projects the stream using the projection" do
      message =
        build_new_message(
          stream_name: "video-1",
          type: "VideoCreated",
          data: %{name: "YouTube Video"}
        )

      MessageStore.write_message(message)

      message =
        build_new_message(
          stream_name: "video-1",
          type: "VideoTitleUpcased",
          data: %{},
          expected_version: 0
        )

      MessageStore.write_message(message)

      %{name: name} = MessageStore.fetch("video-1", FakeProjection)

      assert name == "YOUTUBE VIDEO"
    end
  end
end
