defmodule VideoTutorialsServices.VideoPublishingComponent.Consumers.Commands do
  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands

  use Verity.Consumer, handlers: [Commands.NameVideoHandler, Commands.PublishVideoHandler]
end
