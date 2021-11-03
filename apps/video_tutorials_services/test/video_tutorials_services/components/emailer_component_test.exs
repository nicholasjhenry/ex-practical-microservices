defmodule VideoTutorialsServices.EmailerComponentTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData
  alias VideoTutorialsServices.EmailerComponent.Handlers.Commands

  describe "sending an email" do
    test "given no messsage handle send command" do
      data = %{
        "emailId" => 1,
        "to" => "jane@example.com",
        "subject" => "foo",
        "text" => "Foo",
        "html" => "<p>Foo</p>"
      }

      command =
        MessageData.Read.new(
          id: UUID.uuid4(),
          stream_name: command_stream_name(data["emailId"], :email),
          type: "Send",
          data: data,
          metadata: %{
            "traceId" => UUID.uuid4(),
            "originStreamName" => "sendEmail-1",
            "userId" => UUID.uuid4()
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
            "traceId" => UUID.uuid4()
          },
          data: %{
            "emailId" => UUID.uuid4(),
            "to" => "jane@example.com",
            "subject" => "foo",
            "text" => "Foo",
            "html" => "<p>Foo</p>"
          }
        )

      MessageStore.write_message(event)

      data = %{
        "emailId" => 1,
        "to" => "jane@example.com",
        "subject" => "foo",
        "text" => "Foo",
        "html" => "<p>Foo</p>"
      }

      command =
        MessageData.Read.new(
          id: UUID.uuid4(),
          stream_name: command_stream_name(event.data["emailId"], :email),
          type: "Send",
          data: data,
          metadata: %{"traceId" => UUID.uuid4()},
          position: 0,
          global_position: 11,
          time: NaiveDateTime.local_now()
        )

      assert {:ok, :noop} == Commands.handle_message(command)
    end
  end
end
