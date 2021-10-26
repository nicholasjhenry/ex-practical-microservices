defmodule VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands do
  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands

  # TODO: Support multiple handlers for a single consumer

  def handle_message(command) do
    Commands.PublishVideoHandler.handle_message(command)
    Commands.NameVideoHandler.handle_message(command)
  end
end
