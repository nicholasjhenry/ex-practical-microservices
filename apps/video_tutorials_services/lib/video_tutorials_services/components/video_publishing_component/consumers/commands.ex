defmodule VideoTutorialsServices.VideoPublishingComponent.Consumers.Commands do
  alias VideoTutorialsServices.VideoPublishingComponent.Handlers

  use Verity.Consumer, handler: Handlers.Commands
end
