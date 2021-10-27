defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events do
  use Verity.Consumer.Postgres

  alias VideoTutorialsServices.IdentityComponent.Handlers
  handler(Handlers.Events)
end
