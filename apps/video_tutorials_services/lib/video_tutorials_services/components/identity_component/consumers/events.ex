defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events do
  import Verity.Consumer.Postgres

  alias VideoTutorialsServices.IdentityComponent.Handlers
  handler Handlers.Events
end
