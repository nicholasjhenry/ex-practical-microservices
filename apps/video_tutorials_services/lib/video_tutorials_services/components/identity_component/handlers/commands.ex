defmodule VideoTutorialsServices.IdentityComponent.Handlers.Commands do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.IdentityComponent.Messages.Events.Registered
  alias VideoTutorialsServices.IdentityComponent.Store

  @category :identity

  defmodule AlreadyRegisteredError do
    defexception [:message]
  end

  @impl true
  def handle_message(%{type: "Register"} = register), do: register_user(register)
  def handle_message(_), do: nil

  defp register_user(register) do
    identity_id = register.data["user_id"]
    identity = Store.fetch(identity_id)

    if identity.registered? do
      raise AlreadyRegisteredError
    end

    stream_name = stream_name(register.data["user_id"], @category)
    registered = Registered.follow(register)
    write(registered, stream_name)
  end
end
