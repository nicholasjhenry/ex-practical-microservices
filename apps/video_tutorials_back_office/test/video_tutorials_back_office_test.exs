defmodule VideoTutorialsBackOfficeTest do
  use VideoTutorialsBackOffice.DataCase

  alias MessageStore.MessageData

  test "list events by category name and user_id" do
    user_id = UUID.uuid4()

    event =
      MessageData.Write.new(
        stream_name: "identity-#{user_id}",
        type: "RegistrationEmailSent",
        metadata: %{
          "traceId" => UUID.uuid4(),
          "userId" => user_id
        },
        data: %{
          "userId" => user_id,
          "emailId" => UUID.uuid4()
        },
        # TODO
        expected_version: nil
      )

    MessageStore.write_message(event)

    assert [%{data: data}] =
             VideoTutorialsBackOffice.list_messages(category: "identity", user_id: user_id)

    assert data["userId"] == user_id
  end

  test "list messages by stream name and id" do
    user_id = UUID.uuid4()

    event =
      MessageData.Write.new(
        stream_name: "identity-#{user_id}",
        type: "RegistrationEmailSent",
        metadata: %{
          "traceId" => UUID.uuid4(),
          "userId" => user_id
        },
        data: %{
          "userId" => user_id,
          "emailId" => UUID.uuid4()
        },
        # TODO
        expected_version: nil
      )

    MessageStore.write_message(event)

    assert [%{data: data}] =
             VideoTutorialsBackOffice.list_messages(stream_name: "identity-#{user_id}")

    assert data["userId"] == user_id
  end
end
