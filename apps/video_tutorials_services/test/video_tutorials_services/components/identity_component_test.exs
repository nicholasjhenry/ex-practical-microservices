defmodule VideoTutorialsServices.IdentityComponentTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData

  alias VideoTutorialsServices.IdentityComponent.Handlers
  alias VideoTutorialsServices.IdentityComponent.Projection
  alias VideoTutorialsServices.IdentityComponent.Messages.Commands.Register
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Sent

  test "registering a user" do
    command =
      Register.build(
        %{user_id: "1", trace_id: UUID.uuid4()},
        %{user_id: "1", email: "jane@example.com", password_hash: "abc123#"}
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
      Sent.build(
        %{
          origin_stream_name: "identity-1",
          trace_id: UUID.uuid4(),
          user_id: nil
        },
        data
      )

    assert {:ok, :registration_email_sent} = Handlers.Events.SendEmail.handle_message(event)
  end
end
