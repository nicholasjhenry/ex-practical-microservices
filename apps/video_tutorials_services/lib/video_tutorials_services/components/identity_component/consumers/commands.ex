defmodule VideoTutorialsServices.IdentityComponent.Consumers.Commands do
  alias VideoTutorialsServices.IdentityComponent.Handlers

  use Verity.Consumer, handlers: Handlers.Commands
end
