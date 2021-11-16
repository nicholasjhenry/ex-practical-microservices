defmodule VideoTutorialsServices.IdentityComponentTest do
  use VideoTutorialsServices.DataCase

  alias VideoTutorialsServices.IdentityComponent.Handlers
  alias VideoTutorialsServices.IdentityComponent.Store
  alias VideoTutorialsServices.IdentityComponent.Messages.Commands.Register
  alias VideoTutorialsServices.IdentityComponent.Messages.Events.Registered
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Sent

  import Verity.Messaging.Write
  import Verity.Messaging.StreamName

  test "registering a user" do
    command =
      Register.build(
        %{user_id: "1", trace_id: UUID.uuid4()},
        %{user_id: "1", email: "jane@example.com", password_hash: "abc123#"}
      )

    Handlers.Commands.handle_message(command)

    identity = Store.fetch(1)

    assert identity.id == "1"
    assert identity.email == "jane@example.com"
    assert identity.registered?
  end

  test "sending registration email" do
    registered_event =
      Registered.build(
        %{
          trace_id: UUID.uuid4(),
          user_id: 1
        },
        %{
          user_id: 1,
          email: "jane@example.com",
          password_hash: "abc123#"
        }
      )

    stream_name = stream_name(1, :identity)
    write(registered_event, stream_name)

    event =
      Registered.build(
        %{
          trace_id: registered_event.metadata.trace_id,
          user_id: 1
        },
        %{
          user_id: 1,
          email: "jane@example.com",
          password_hash: "abc123#"
        }
      )

    assert {:ok, :registration_email_requested} == Handlers.Events.handle_message(event)
  end

  test "handle email sent events" do
    registered_event =
      Registered.build(
        %{
          trace_id: UUID.uuid4(),
          user_id: 1
        },
        %{
          user_id: 1,
          email: "jane@example.com",
          password_hash: "abc123#"
        }
      )

    stream_name = stream_name(1, :identity)
    write(registered_event, stream_name)

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
