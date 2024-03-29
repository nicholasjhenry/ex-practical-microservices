defmodule MessageStore.ConsumerWorkerTest do
  use ExUnit.Case

  alias MessageStore.{MessageData, Repo, ConsumerWorker}

  setup do
    start_supervised!(Repo)
    Repo.truncate_messages()
    me = self()

    handler = fn message ->
      send(me, {:message_processed, message.id})
    end

    args = [config: %{stream_name: "subscriber-foo", subscribed_to: "video", handler: handler}]
    worker = start_supervised!({ConsumerWorker, args})

    [worker: worker]
  end

  test "works", %{worker: _worker} do
    message =
      MessageData.Write.new(
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "video-1",
        type: "VideoCreated",
        data: %{name: "YouTube Video"}
      )

    MessageStore.write_message(message)

    assert_receive {:message_processed, "5e731bdc-07aa-430a-8aae-543b45dd7235"}
  end
end
