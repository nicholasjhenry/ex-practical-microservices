defmodule VideoTutorials.Identity do
  defstruct [:id, :email, :registered?]

  alias MessageStore.NewMessage

  defmodule AlreadyRegisteredError do
    defexception [:message]
  end

  def init do
    %__MODULE__{registered?: false}
  end

  def apply(identity, %{type: "Registered", data: data}) do
    %{identity | id: data["user_id"], email: data["email"], registered?: true}
  end

  def handle_message(command) do
    register_user(command)
  end

  def register_user(command) do
    context = %{command: command, identity_id: command.data["user_id"], identity: nil}

    context
    |> load_identity
    |> ensure_not_registered
    |> write_registered_event
  end

  defp load_identity(context) do
    identity_stream_name = "identity-#{context.identity_id}"

    maybe_identity = MessageStore.fetch(identity_stream_name, __MODULE__)

    Map.put(context, :identity, maybe_identity)
  end

  defp ensure_not_registered(context) do
    if context.identity.registered? do
      raise AlreadyRegisteredError
    end

    context
  end

  defp write_registered_event(context) do
    command = context.command

    registered_event = NewMessage.new(
      stream_name: "identity-#{command.data["user_id"]}",
      type: "Registered",
      metadata: %{
        trace_id: Map.fetch!(command.metadata, "trace_id"),
        user_id: Map.fetch!(command.metadata, "user_id")
      },
      data: %{
        user_id: Map.fetch!(command.data, "user_id"),
        email: Map.fetch!(command.data, "email"),
        password_hash: Map.fetch!(command.data, "password_hash")
      }
    )

    MessageStore.write_message(registered_event)
  end
end
