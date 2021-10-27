defmodule VideoTutorialsServices.EmailerComponent.Consumers.Commands do
  use Verity.Consumer.Postgres

  alias VideoTutorialsServices.EmailerComponent.Handlers
  handler(Handlers.Commands)
end
