defmodule VideoTutorialsServices.AdminSubscriberPositionsTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData
  alias VideoTutorialsData.AdminSubscriberPosition
  alias VideoTutorialsServices.AdminSubscriberPositions

  test "handling component Read events" do
    message =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "components:subscriber-1",
        type: "Read",
        data: %{"postition" => 0},
        metadata: %{},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    AdminSubscriberPositions.handle_message(message)

    assert position = Repo.get(AdminSubscriberPosition, "1")
    assert position.position == 0
    assert position.last_message_global_position == 11

    message =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "components:subscriber-1",
        type: "Read",
        data: %{"postition" => 1},
        metadata: %{},
        position: 1,
        global_position: 12,
        time: NaiveDateTime.local_now()
      )

    AdminSubscriberPositions.handle_message(message)

    assert position = Repo.get(AdminSubscriberPosition, "1")
    assert position.position == 1
    assert position.last_message_global_position == 12

    # # Older message
    AdminSubscriberPositions.handle_message(message)

    assert position = Repo.get(AdminSubscriberPosition, "1")
    assert position.position == 1
    assert position.last_message_global_position == 12
  end

  test "ignores other messages" do
    message =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "components:subscriber-1",
        type: "Any",
        data: %{"postition" => 0},
        metadata: %{},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    AdminSubscriberPositions.handle_message(message)

    refute Repo.get(AdminSubscriberPosition, "1")
  end
end
