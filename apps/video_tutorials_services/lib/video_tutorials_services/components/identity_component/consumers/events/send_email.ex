defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.SendEmail do
  alias VideoTutorialsServices.IdentityComponent.Handlers

  use Verity.Consumer, identifier: :identity, handlers: Handlers.Events.SendEmail
end
