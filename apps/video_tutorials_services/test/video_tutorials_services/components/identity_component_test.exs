defmodule VideoTutorialsServices.IdentityComponentTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData

  alias VideoTutorialsServices.IdentityComponent.Handlers
  alias VideoTutorialsServices.IdentityComponent.Projection

  test "registering a user" do
    command =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: command_stream_name(1, :identity),
        type: "Register",
        data: %{"userId" => "1", "email" => "jane@example.com", "passwordHash" => "abc123#"},
        metadata: %{"userId" => "1", "traceId" => UUID.uuid4()},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    Handlers.Commands.handle_message(command)

    identity = MessageStore.fetch("identity-1", Projection)

    assert identity.id == "1"
    assert identity.email == "jane@example.com"
    assert identity.registered?
  end

  test "sending registration email" do
    registered_event =
      MessageData.Write.new(
        stream_name: "identity-1",
        type: "Registered",
        metadata: %{
          "traceId" => UUID.uuid4(),
          "userId" => 1
        },
        data: %{
          "userId" => 1,
          "email" => "jane@example.com",
          "passwordHash" => "abc123#"
        }
      )

    MessageStore.write_message(registered_event)

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "identity-1",
        type: "Registered",
        data: %{"userId" => "1", "email" => "jane@example.com", "passwordHash" => "abc123#"},
        metadata: %{"userId" => "1", "traceId" => registered_event.metadata["traceId"]},
        position: 0,
        global_position: 1,
        time: NaiveDateTime.local_now()
      )

    Handlers.Events.handle_message(event)
  end

  test "handle email sent events" do
    registered_event =
      MessageData.Write.new(
        stream_name: "identity-1",
        type: "Registered",
        metadata: %{
          "traceId" => UUID.uuid4(),
          "userId" => 1
        },
        data: %{
          "userId" => 1,
          "email" => "jane@example.com",
          "passwordHash" => "abc123#"
        }
      )

    MessageStore.write_message(registered_event)

    data = %{
      "emailId" => "1",
      "userId" => "1",
      "to" => "jane@example.com",
      "subject" => "Registered!",
      "text" => "Welcome",
      "html" => "<i>Welcome</i>"
    }

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "sendEmail-1",
        type: "Sent",
        metadata: %{
          "originStreamName" => "identity-1",
          "traceId" => UUID.uuid4()
        },
        data: data,
        position: 0,
        global_position: 1,
        time: NaiveDateTime.local_now()
      )

    assert {:ok, :registration_email_sent} = Handlers.Events.SendEmail.handle_message(event)
  end
end
