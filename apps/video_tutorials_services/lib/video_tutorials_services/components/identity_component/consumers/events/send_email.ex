defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.SendEmail do
  alias VideoTutorialsServices.IdentityComponent.Handlers

  use Verity.Consumer, identifier: :identity, handler: Handlers.Events.SendEmail
end
