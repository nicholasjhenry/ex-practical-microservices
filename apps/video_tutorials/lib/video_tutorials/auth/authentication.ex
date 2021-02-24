defmodule VideoTutorials.Authentication do
  alias VideoTutorialsData.Repo
  alias VideoTutorials.{Login, Password, UserCredential}
  alias MessageStore.NewMessage

  defstruct [:trace_id, :endpoint, :email, :password, :user_credential, :signature]

  import Plug.Conn, only: [put_session: 3, configure_session: 2]

  def change_login(login, attrs \\ %{}) do
    Login.changeset(login, attrs)
  end

  def login(conn, user_id) do
    conn
    |> put_session(:token, sign(conn, user_id))
    |> configure_session(renew: true)
  end

  def authenticate(endpoint, %{"email" => email, "password" => password}) do
    context = %__MODULE__{endpoint: endpoint, email: email, password: password, trace_id: UUID.uuid4}

    with context <- load_user_credential(context),
      {:ok, context} <- ensure_user_credential_found(context),
      {:ok, context} <- validate_password(context),
      context <- sign_token(context),
      context <- write_logged_in_event(context) do
      {:ok, context.signature}
    else
      {:error, {:not_found_error, context}} -> handle_credential_not_found(context)
      {:error, {:credentials_mismatch, context}} -> handle_credentials_mismatch(context)
    end
  end

  defp load_user_credential(context) do
    user_credential = get_user_credential(context.email)
     Map.put(context, :user_credential, user_credential)
  end

  defp get_user_credential(email) do
    Repo.get_by(UserCredential, email: email)
  end

  def validate_password(context) do
    if Password.equal?(context.password, context.user_credential.password_hash) do
      {:ok, context}
    else
      {:error, {:credentials_mismatch, context}}
    end
  end

  def sign_token(context) do
    Map.put(context, :signature, sign(context.endpoint, context.email))
  end

  def ensure_user_credential_found(context) do
    case context.user_credential do
      nil -> {:error, {:not_found_error, context}}
      %UserCredential{} -> {:ok, context}
    end
  end

  defp write_logged_in_event(context) do
    event = NewMessage.new(
      stream_name: "authentication-#{context.user_credential.id}",
      type: "UserLoggedIn",
      metadata: %{
        trace_id: context.trace_id,
        user_id: context.user_credential.id
      },
      data: %{
        user_id: context.user_credential.id
      }
    )

    MessageStore.write_message(event)

    context
  end

  defp handle_credential_not_found(_context) do
    {:error, :authentication_error}
  end

  defp handle_credentials_mismatch(context) do
    event = NewMessage.new(
      stream_name: "authentication-#{context.user_credential.id}",
      type: "UserLoginFailed",
      metadata: %{
        trace_id: context.trace_id,
        user_id: nil
      },
      data: %{
        user_id: context.user_credential.id,
        reason: "Incorrect password"
      }
    )

    MessageStore.write_message(event)

    {:error, :authentication_error}
  end

  defdelegate sign(conn, data), to: VideoTutorials.Token
  defdelegate verify(conn, token, opts \\ []), to: VideoTutorials.Token
end
