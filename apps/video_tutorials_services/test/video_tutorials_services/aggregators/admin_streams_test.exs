defmodule VideoTutorialsServices.AdminStreamsTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData

  alias VideoTutorialsData.AdminStream
  alias VideoTutorialsServices.AdminStreams

  test "handling all message" do
    user_id = UUID.uuid4()

    message =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "identity-1",
        type: "Registered",
        data: %{"userId" => user_id, "email" => "jane@example.com", "passwordHash" => "abc123#"},
        metadata: %{"userId" => user_id, "traceId" => UUID.uuid4()},
        position: 1,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    AdminStreams.handle_message(message)

    assert stream = Repo.get(AdminStream, "identity-1")
    assert stream.stream_name == "identity-1"
    assert stream.message_count == 1
    assert stream.last_message_id == message.id
    assert stream.last_message_global_position == 11

    next_message =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "identity-1",
        type: "RegistrationCanceled",
        data: %{"userId" => user_id},
        metadata: %{"userId" => user_id, "traceId" => UUID.uuid4()},
        position: 2,
        global_position: 12,
        time: NaiveDateTime.local_now()
      )

    AdminStreams.handle_message(next_message)

    assert stream = Repo.get(AdminStream, "identity-1")
    assert stream.stream_name == "identity-1"
    assert stream.message_count == 2
    assert stream.last_message_id == next_message.id
    assert stream.last_message_global_position == 12

    # Older message
    AdminStreams.handle_message(message)

    assert stream = Repo.get(AdminStream, "identity-1")
    assert stream.stream_name == "identity-1"
    assert stream.message_count == 2
    assert stream.last_message_id == next_message.id
    assert stream.last_message_global_position == 12
  end
end
