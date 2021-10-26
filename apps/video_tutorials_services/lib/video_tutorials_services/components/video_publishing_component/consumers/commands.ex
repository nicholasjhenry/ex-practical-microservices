defmodule VideoTutorialsServices.VideoPublishingComponent.Consumers.Commands do
  use Verity.Consumer.Postgres

  alias VideoTutorialsServices.VideoPublishingComponent.Handlers
  handler Handlers.Commands
end
