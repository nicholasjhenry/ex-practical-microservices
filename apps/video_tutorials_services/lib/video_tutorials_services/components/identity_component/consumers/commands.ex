defmodule VideoTutorialsServices.IdentityComponent.Consumers.Commands do
  import Verity.Consumer.Postgres

  alias VideoTutorialsServices.IdentityComponent.Handlers
  handler Handlers.Commands
end
