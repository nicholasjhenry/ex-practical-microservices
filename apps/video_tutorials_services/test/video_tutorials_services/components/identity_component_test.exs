defmodule VideoTutorialsServices.IdentityComponentTest do
  use VideoTutorialsServices.DataCase

  alias VideoTutorialsServices.IdentityComponent.IdentityHandler
  alias MessageStore.{Message, NewMessage}

  test "registering a user" do
    command =
      Message.new(
        id: UUID.uuid4(),
        stream_name: "identity:command-1",
        type: "Register",
        data: %{"user_id" => "1", "email" => "jane@example.com", "password_hash" => "abc123#"},
        metadata: %{"user_id" => "1", "trace_id" => UUID.uuid4()},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    IdentityHandler.handle_message(command)

    identity = MessageStore.fetch("identity-1", IdentityHandler)

    assert identity.id == "1"
    assert identity.email == "jane@example.com"
    assert identity.registered?
  end

  test "sending registration email" do
    registered_event =
      NewMessage.new(
        stream_name: "identity-1",
        type: "Registered",
        metadata: %{
          trace_id: UUID.uuid4(),
          user_id: 1
        },
        data: %{
          user_id: 1,
          email: "jane@example.com",
          password_hash: "abc123#"
        }
      )

    MessageStore.write_message(registered_event)

    event =
      Message.new(
        id: UUID.uuid4(),
        stream_name: "identity-1",
        type: "Registered",
        data: %{"user_id" => "1", "email" => "jane@example.com", "password_hash" => "abc123#"},
        metadata: %{"user_id" => "1", "trace_id" => registered_event.metadata["trace_id"]},
        position: 0,
        global_position: 1,
        time: NaiveDateTime.local_now()
      )

      IdentityHandler.handle_message(event)
  end

  test "handle email sent events" do
    registered_event =
      NewMessage.new(
        stream_name: "identity-1",
        type: "Registered",
        metadata: %{
          trace_id: UUID.uuid4(),
          user_id: 1
        },
        data: %{
          user_id: 1,
          email: "jane@example.com",
          password_hash: "abc123#"
        }
      )

    MessageStore.write_message(registered_event)

    event =
      Message.new(
        id: UUID.uuid4(),
        stream_name: "sendEmail-1",
        type: "Sent",
        metadata: %{
          "origin_stream_name" => "identity-1",
          "trace_id" => UUID.uuid4()
        },
        data: %{"email_id" => "1", "user_id" => "1"},
        position: 0,
        global_position: 1,
        time: NaiveDateTime.local_now()
      )

    assert {:ok, :registration_email_sent} = IdentityHandler.handle_message(event)
  end
end
