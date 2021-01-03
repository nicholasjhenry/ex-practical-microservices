defmodule VideoTutorials.SendEmailTest do
  use VideoTutorials.DataCase

  alias MessageStore.{Message, NewMessage}
  alias VideoTutorials.SendEmail

  describe "sending an email" do
    test "given no messsage handle send command" do
      data =
        %{
          "email_id" => 1,
          "to" => "jane@example.com",
          "subject" => "foo",
          "text" => "Foo",
          "html" => "<p>Foo</p>"
      }

      command = Message.new(
        id: UUID.uuid4,
        stream_name: "email:command-1",
        type: "Send",
        data: data,
        metadata: %{"traceId" => UUID.uuid4, "originalStreamName" => "sendEmail-1", "userId" => UUID.uuid4},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

      {:ok, :email_sent} = SendEmail.handle(command)
    end

    test "given a message handles the send command" do
      event = NewMessage.new(
        stream_name: "sendEmail-1",
        type: "Sent",
        metadata: %{
          trace_id: UUID.uuid4
        },
        data: %{
          email_id: UUID.uuid4
        }
      )

      MessageStore.write_message(event)

      command = Message.new(
        id: UUID.uuid4,
        stream_name: "email:command-1",
        type: "Send",
        data: %{"email_id" => 1},
        metadata: %{"trace_id" => UUID.uuid4},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

      assert {:ok, :noop} == SendEmail.handle(command)
    end
  end
end
