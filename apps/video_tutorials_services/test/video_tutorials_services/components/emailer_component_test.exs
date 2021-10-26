defmodule VideoTutorialsServices.EmailerComponentTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData
  alias VideoTutorialsServices.EmailerComponent.Handlers.Commands

  describe "sending an email" do
    test "given no messsage handle send command" do
      data = %{
        "email_id" => 1,
        "to" => "jane@example.com",
        "subject" => "foo",
        "text" => "Foo",
        "html" => "<p>Foo</p>"
      }

      command =
        MessageData.Read.new(
          id: UUID.uuid4(),
          stream_name: command_stream_name(data["email_id"], :email),
          type: "Send",
          data: data,
          metadata: %{
            "trace_id" => UUID.uuid4(),
            "origin_stream_name" => "sendEmail-1",
            "user_id" => UUID.uuid4()
          },
          position: 0,
          global_position: 11,
          time: NaiveDateTime.local_now()
        )

      {:ok, :email_sent} = Commands.handle_message(command)
    end

    test "given a message handles the send command" do
      event =
        MessageData.Write.new(
          stream_name: "sendEmail-1",
          type: "Sent",
          metadata: %{
            trace_id: UUID.uuid4()
          },
          data: %{
            email_id: UUID.uuid4()
          }
        )

      MessageStore.write_message(event)

      command =
        MessageData.Read.new(
          id: UUID.uuid4(),
          stream_name: command_stream_name(event.data.email_id, :email),
          type: "Send",
          data: %{"email_id" => 1},
          metadata: %{"trace_id" => UUID.uuid4()},
          position: 0,
          global_position: 11,
          time: NaiveDateTime.local_now()
        )

      assert {:ok, :noop} == Commands.handle_message(command)
    end
  end
end
