defmodule VideoTutorialsServices.IdentityComponent.Consumers.Events.SendEmail do
  use Verity.Consumer.Postgres

  alias VideoTutorialsServices.IdentityComponent.Handlers

  identifier("identity")
  handler(Handlers.Events.SendEmail)
end
