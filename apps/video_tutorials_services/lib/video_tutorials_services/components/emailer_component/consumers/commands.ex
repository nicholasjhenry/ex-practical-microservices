defmodule VideoTutorialsServices.EmailerComponent.Consumers.Commands do
  import Verity.Consumer.Postgres

  alias VideoTutorialsServices.EmailerComponent.Handlers
  handler Handlers.Commands
end
