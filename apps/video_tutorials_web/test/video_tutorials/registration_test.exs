defmodule VideoTutorials.RegistrationTest do
  use VideoTutorials.DataCase

  alias VideoTutorialsData.UserCredential
  alias VideoTutorials.Registration

  def fixture(:registration) do
    %Registration{}
  end

  test "changing a registration returns a changeset" do
    registration = fixture(:registration)
    assert %Ecto.Changeset{} = Registration.change_registration(registration)
  end

  test "registering a user with valid data registers a user" do
    valid_attrs = %{id: UUID.uuid4(), email: "jane@example.com", password: "abc1234"}

    assert :ok = Registration.register_user(valid_attrs)
  end

  test "registering a user with invalid data returns an error changeset" do
    invalid_attrs = %{password: "abc1234"}

    assert {:error, %Ecto.Changeset{}} = Registration.register_user(invalid_attrs)
  end

  test "registering a user with existing email returns an error changeset" do
    Repo.insert!(%UserCredential{email: "jane@example.com", password_hash: "abc123#"})
    valid_attrs = %{id: UUID.uuid4(), email: "jane@example.com", password: "abc1234"}

    assert {:error, %Ecto.Changeset{}} = Registration.register_user(valid_attrs)
  end

  test "get existing identity with no matching record returns a empty list" do
    assert nil == Registration.get_user_credential_by_email("jane@example.com")
  end

  test "get existing identity with matching record returns the record" do
    Repo.insert!(%UserCredential{email: "jane@example.com", password_hash: "abc123#"})

    assert %UserCredential{} = Registration.get_user_credential_by_email("jane@example.com")
  end
end
