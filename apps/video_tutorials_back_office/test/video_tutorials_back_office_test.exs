defmodule VideoTutorialsBackOfficeTest do
  use VideoTutorialsBackOffice.DataCase

  alias MessageStore.NewMessage

  test "list events by category name and user_id" do
    user_id = UUID.uuid4
    event = NewMessage.new(
      stream_name: "identity-#{user_id}",
      type: "RegistrationEmailSent",
      metadata: %{
        trace_id: UUID.uuid4,
        user_id: user_id
      },
      data: %{
        user_id: user_id,
        email_id: UUID.uuid4,
      },
      # TODO
      expected_version: nil
    )

    MessageStore.write_message(event)

    assert [%{data: data}] = VideoTutorialsBackOffice.list_messages(category: "identity", user_id: user_id)
    assert data["user_id"] == user_id
  end

  test "list messages by stream name and id" do
    user_id = UUID.uuid4
    event = NewMessage.new(
      stream_name: "identity-#{user_id}",
      type: "RegistrationEmailSent",
      metadata: %{
        trace_id: UUID.uuid4,
        user_id: user_id
      },
      data: %{
        user_id: user_id,
        email_id: UUID.uuid4,
      },
      # TODO
      expected_version: nil
    )

    MessageStore.write_message(event)

    assert [%{data: data}] = VideoTutorialsBackOffice.list_messages(stream_name: "identity-#{user_id}")
    assert data["user_id"] == user_id
  end
end
