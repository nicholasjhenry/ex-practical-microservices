defmodule VideoTutorials.Registration do
  alias VideoTutorialsData.{Repo, UserCredential}
  alias VideoTutorials.Password

  use Ecto.Schema
  import Ecto.Changeset
  import Verity.Messaging.StreamName

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  defmodule Context do
    @moduledoc false

    defstruct [:changeset, :existing_identity, :trace_id, :password_hash]
  end

  def change_registration(registration, attrs \\ %{}) do
    registration
    |> cast(attrs, [:id, :email, :password])
    |> validate_required([:id, :email, :password])
    |> validate_length(:password, min: 6)
  end

  def register_user(attrs) do
    %Context{trace_id: UUID.uuid4()}
    |> validate(attrs)
    |> load_existing_identity
    |> ensure_there_was_no_existing_identity
    |> hash_password
    |> write_register_command
    |> determine_result
  end

  def get_user_credential_by_email(email) do
    import Ecto.Query, only: [from: 2]

    query = from(user in UserCredential, where: user.email == ^email, select: [:id])
    query |> Repo.all() |> List.first()
  end

  defp validate(context, attrs) do
    changeset = change_registration(%__MODULE__{}, attrs)
    Map.put(context, :changeset, changeset)
  end

  defp load_existing_identity(context) do
    case Ecto.Changeset.get_change(context.changeset, :email) do
      nil ->
        context

      email ->
        user_credential = get_user_credential_by_email(email)
        Map.put(context, :existing_identity, user_credential)
    end
  end

  defp ensure_there_was_no_existing_identity(context) do
    case context.existing_identity do
      nil ->
        context

      %UserCredential{} ->
        changeset = Ecto.Changeset.add_error(context.changeset, :email, "already taken")
        Map.put(context, :changeset, changeset)
    end
  end

  defp hash_password(context) do
    case Ecto.Changeset.get_change(context.changeset, :password) do
      nil ->
        context

      password ->
        password_hash = Password.hash(password)
        Map.put(context, :password_hash, password_hash)
    end
  end

  defp write_register_command(context) do
    case Ecto.Changeset.apply_action(context.changeset, :executed) do
      {:ok, registration} ->
        stream_name = command_stream_name(registration.id, :identity)

        command =
          MessageStore.MessageData.Write.new(
            stream_name: stream_name,
            type: "Register",
            metadata: %{
              trace_id: context.trace_id,
              user_id: registration.id
            },
            data: %{
              user_id: registration.id,
              email: registration.email,
              password_hash: context.password_hash
            }
          )

        MessageStore.write_message(command)

        context

      {:error, _} ->
        context
    end
  end

  defp determine_result(context) do
    if context.changeset.valid? do
      :ok
    else
      {:error, Map.put(context.changeset, :action, :validate)}
    end
  end
end
