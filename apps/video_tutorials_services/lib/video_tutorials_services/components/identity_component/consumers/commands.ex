defmodule VideoTutorialsServices.IdentityComponent.Consumers.Commands do
  alias VideoTutorialsServices.IdentityComponent.Handlers

  use Verity.Consumer, handler: Handlers.Commands
end
