defmodule VideoTutorials.RegisterUsers do
  alias VideoTutorials.Registration

  def change_registration(registration, attrs \\ %{}) do
    Registration.changeset(registration, attrs)
  end

  def register_user(attrs) do
    changeset = Registration.changeset(%Registration{}, attrs)
    if changeset.valid? do
      :ok
    else
      {:error, Map.put(changeset, :action, :validate)}
    end
  end
end
