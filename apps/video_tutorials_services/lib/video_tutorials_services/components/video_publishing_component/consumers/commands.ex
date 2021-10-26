defmodule VideoTutorialsServices.VideoPublishingComponent.Consumers.Commands do
  import Verity.Consumer.Postgres

  alias VideoTutorialsServices.VideoPublishingComponent.Handlers
  handler Handlers.Commands
end
