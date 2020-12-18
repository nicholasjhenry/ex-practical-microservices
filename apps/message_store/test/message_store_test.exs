defmodule MessageStoreTest do
  use ExUnit.Case

  alias MessageStore.Repo

  setup do
    Repo.truncate_messages()
    :ok
  end

  test "writes a message to a stream" do
    start_supervised!(MessageStore.Repo)

    message = %{
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
end
