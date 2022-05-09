defmodule VideoTutorialsServices.IdentityComponent.Handlers.Commands do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.IdentityComponent.Messages.Commands.Register
  alias VideoTutorialsServices.IdentityComponent.Messages.Events.Registered
  alias VideoTutorialsServices.IdentityComponent.Store

  defmodule AlreadyRegisteredError do
    defexception [:message]
  end

  def handle_message(%Register{} = register) do
    {identity, version} = Store.fetch(register.user_id, include: [:version])

    if identity.registered? do
      raise AlreadyRegisteredError
    end

    stream_name = stream_name(register.user_id, :identity)
    registered = Registered.follow(register)
    write(registered, stream_name, expected_version: version)
  end

  def handle_message(_message_data), do: :ok
end
