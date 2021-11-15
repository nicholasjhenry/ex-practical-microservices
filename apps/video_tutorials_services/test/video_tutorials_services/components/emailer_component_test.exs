defmodule VideoTutorialsServices.EmailerComponentTest do
  use VideoTutorialsServices.DataCase

  alias VideoTutorialsServices.EmailerComponent.Handlers.Commands
  alias VideoTutorialsServices.EmailerComponent.Messages.Commands.Send

  describe "sending an email" do
    test "given no messsage handle send command" do
      data = %{
        email_id: 1,
        to: "jane@example.com",
        subject: "foo",
        text: "Foo",
        html: "<p>Foo</p>"
      }

      command =
        Send.build(
          %{
            trace_id: UUID.uuid4(),
            origin_stream_name: "sendEmail-1",
            user_id: UUID.uuid4()
          },
          data
        )

      {:ok, :email_sent} = Commands.handle(command)
    end

    test "given a message handles the send command" do
      data = %{
        email_id: 1,
        to: "jane@example.com",
        subject: "foo",
        text: "Foo",
        html: "<p>Foo</p>"
      }

      command =
        Send.build(
          %{
            trace_id: UUID.uuid4(),
            origin_stream_name: "sendEmail-1",
            user_id: UUID.uuid4()
          },
          data
        )

      {:ok, :email_sent} = Commands.handle(command)

      command =
        Send.build(
          %{
            trace_id: UUID.uuid4(),
            origin_stream_name: "sendEmail-1",
            user_id: UUID.uuid4()
          },
          data
        )

      assert {:ok, :noop} == Commands.handle(command)
    end
  end
end
