defmodule VideoTutorials.RegisterUsersTest do
  use VideoTutorials.DataCase

  alias VideoTutorials.{RegisterUsers, Registration}

  def fixture(:registration) do
    %Registration{}
  end

  test "changing a registration returns a changeset" do
    registration = fixture(:registration)
    assert %Ecto.Changeset{} = RegisterUsers.change_registration(registration)
  end

  test "registering a user with valid data registers a user" do
    valid_attrs = %{id: UUID.uuid4(), email: "jane@example.com", password: "abc1234"}

    assert :ok = RegisterUsers.register_user(valid_attrs)
  end

  test "registering a user with valid data returns an error changeset" do
    invalid_attrs = %{password: "abc1234"}

    assert {:error, %Ecto.Changeset{}} = RegisterUsers.register_user(invalid_attrs)
  end
end
