defmodule VideoTutorialsServices.IdentityComponent.Handlers.Commands do
  import Verity.Messaging.StreamName
  import Verity.Messaging.Write

  alias VideoTutorialsServices.IdentityComponent.Messages.Events.Registered
  alias VideoTutorialsServices.IdentityComponent.Store

  @category "identity"

  defmodule AlreadyRegisteredError do
    defexception [:message]
  end

  def handle_message(%{type: "Register"} = register) do
    identity_id = register.data["user_id"]
    identity = Store.fetch(identity_id)

    if identity.registered? do
      raise AlreadyRegisteredError
    end

    stream_name = stream_name(@category, register.data["user_id"])
    registered = Registered.follow(register)
    write(registered, stream_name)
  end
end
