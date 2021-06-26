
defmodule VideoTutorialsServices.AdminSubscriberPositionsTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.Message
  alias VideoTutorialsData.AdminSubscriberPosition
  alias VideoTutorialsServices.AdminSubscriberPositions

  test "handling all messages" do
      message = Message.new(
        id: UUID.uuid4,
        stream_name: "subscriber-1",
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

      message = Message.new(
        id: UUID.uuid4,
        stream_name: "subscriber-1",
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
end
