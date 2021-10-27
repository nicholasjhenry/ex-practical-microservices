defmodule VideoTutorialsServices.IdentityComponent.Consumers.Commands do
  use Verity.Consumer.Postgres

  alias VideoTutorialsServices.IdentityComponent.Handlers
  handler(Handlers.Commands)
end
