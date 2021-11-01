defmodule VideoTutorialsServices.VideoPublishingComponent.Consumers.Commands do
  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands

  use Verity.Consumer, handler: [Commands.NameVideoHandler, Commands.PublishVideoHandler]
end
