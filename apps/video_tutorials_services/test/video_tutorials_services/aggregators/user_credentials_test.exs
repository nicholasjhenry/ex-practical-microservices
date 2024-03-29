defmodule VideoTutorialsServices.UserCredentialsTest do
  use VideoTutorialsServices.DataCase

  alias VideoTutorialsData.UserCredential
  alias VideoTutorialsServices.UserCredentials
  alias MessageStore.MessageData

  test "handling a registration events" do
    user_id = UUID.uuid4()

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "identity-1",
        type: "Registered",
        data: %{"userId" => user_id, "email" => "jane@example.com", "passwordHash" => "abc123#"},
        metadata: %{"userId" => user_id, "traceId" => UUID.uuid4()},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    UserCredentials.handle_message(event)

    user_credential = Repo.one(UserCredential)
    assert user_credential.id == user_id
    assert user_credential.email == "jane@example.com"
    assert user_credential.password_hash == "abc123#"
  end
end
