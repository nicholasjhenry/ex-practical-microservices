defmodule VideoTutorialsServices.AdminUsersTest do
  use VideoTutorialsServices.DataCase

  alias MessageStore.MessageData
  alias VideoTutorialsData.AdminUser
  alias VideoTutorialsServices.AdminUsers

  test "handling a registration events" do
    user_id = UUID.uuid4()

    event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "identity-1",
        type: "Registered",
        data: %{"user_id" => user_id, "email" => "jane@example.com", "password_hash" => "abc123#"},
        metadata: %{"user_id" => user_id, "trace_id" => UUID.uuid4()},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    AdminUsers.handle_message(event)

    assert user = Repo.one(AdminUser)
    assert user.id == user_id
    assert user.email == "jane@example.com"
    assert user.last_identity_event_global_position == 11
  end

  test "handling registration email sent events" do
    user_id = UUID.uuid4()

    registered_event =
      MessageData.Read.new(
        id: UUID.uuid4(),
        stream_name: "identity-#{user_id}",
        type: "RegistrationEmailSent",
        data: %{
          "user_id" => user_id,
          "email_id" => UUID.uuid4()
        },
        metadata: %{"user_id" => user_id, "trace_id" => UUID.uuid4()},
        position: 0,
        global_position: 11,
        time: NaiveDateTime.local_now()
      )

    AdminUsers.handle_message(registered_event)

    assert user = Repo.one(AdminUser)
    assert user.id == user_id
    assert user.registration_email_sent
    assert user.last_identity_event_global_position == 11
  end
end
