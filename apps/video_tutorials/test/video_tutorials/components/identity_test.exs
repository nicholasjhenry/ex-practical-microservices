defmodule VideoTutorials.IdentityTest do
  use VideoTutorials.DataCase

  alias VideoTutorials.Identity
  alias MessageStore.Message

  test "registering a user" do
    command = Message.new(
      id: UUID.uuid4,
      stream_name: "identity:command-1",
      type: "Registered",
      data: %{"user_id" => "1", "email" => "jane@example.com", "password_hash" => "abc123#"},
      metadata: %{"user_id" => "1", "trace_id" => UUID.uuid4},
      position: 0,
      global_position: 11,
      time: NaiveDateTime.local_now()
    )

    Identity.handle_message(command)

    identity = MessageStore.fetch("identity-1", Identity)

    assert identity.id == "1"
    assert identity.email == "jane@example.com"
    assert identity.registered?
  end
end
