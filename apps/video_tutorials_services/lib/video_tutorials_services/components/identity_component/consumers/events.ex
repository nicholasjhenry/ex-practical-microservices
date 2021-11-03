defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events do
  alias VideoTutorialsServices.IdentityComponent.Handlers

  use Verity.Consumer, identifier: :identity, handlers: Handlers.Events
end
