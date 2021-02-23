defmodule VideoTutorials.UserCredentialsTest do
  use VideoTutorials.DataCase

  alias VideoTutorials.{UserCredential, UserCredentials}
  alias MessageStore.Message

  test "handling a registration events" do
      user_id = UUID.uuid4

      event = Message.new(
        id: UUID.uuid4,
        stream_name: "identity-1",
        type: "Registered",
        data: %{"user_id" => user_id, "email" => "jane@example.com", "password_hash" => "abc123#"},
        metadata: %{"user_id" => user_id, "trace_id" => UUID.uuid4},
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
