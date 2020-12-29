defmodule VideoTutorials.RegisterUsers do
  alias VideoTutorials.{Registration, Repo, UserCredential}

  defstruct [:changeset, :existing_identity]

  def change_registration(registration, attrs \\ %{}) do
    Registration.changeset(registration, attrs)
  end

  def register_user(attrs) do
    context = %__MODULE__{}
      |> validate(attrs)
      |> load_existing_identity
      |> ensure_there_was_no_existing_identity
      |> hash_password
      |> write_register_command

    if context.changeset.valid? do
      :ok
    else
      {:error, Map.put(context.changeset, :action, :validate)}
    end
  end

  def get_user_credential_by_email(email) do
    import Ecto.Query, only: [from: 2]

    query = from(user in UserCredential, where: user.email == ^email, select: [:id])
    query |> Repo.all |> List.first
  end

  defp validate(context, attrs) do
    changeset = Registration.changeset(%Registration{}, attrs)
    Map.put(context, :changeset, changeset)
  end

  defp load_existing_identity(context) do
    case Ecto.Changeset.get_change(context.changeset, :email) do
      nil -> context
      email ->
        user_credential = get_user_credential_by_email(email)
        Map.put(context, :existing_identity, user_credential)
    end
  end

  defp ensure_there_was_no_existing_identity(context) do
    case context.existing_identity do
      nil -> context
      %UserCredential{} ->
        changeset = Ecto.Changeset.add_error(context.changeset, :email, "already taken")
        Map.put(context, :changeset, changeset)
    end
  end

  defp hash_password(context) do
    context
  end

  defp write_register_command(context) do
    context
  end
end
