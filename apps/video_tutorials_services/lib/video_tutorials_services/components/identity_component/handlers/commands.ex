defmodule VideoTutorialsServices.IdentityComponent.Handlers.Commands do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.IdentityComponent.Messages.Commands.Register
  alias VideoTutorialsServices.IdentityComponent.Messages.Events.Registered
  alias VideoTutorialsServices.IdentityComponent.Store

  defmodule AlreadyRegisteredError do
    defexception [:message]
  end

  @impl true
  def handle_message(%{type: "Register"} = message_data) do
    message_data |> Register.parse() |> register_user()
  end

  def handle_message(_), do: nil

  defp register_user(register) do
    identity = Store.fetch(register.user_id)

    if identity.registered? do
      raise AlreadyRegisteredError
    end

    stream_name = stream_name(register.user_id, :identity)
    registered = Registered.follow(register)
    write(registered, stream_name)
  end
end
