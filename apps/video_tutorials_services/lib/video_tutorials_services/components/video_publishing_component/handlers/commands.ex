defmodule VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands do
  use Verity.Messaging.Handler

  alias VideoTutorialsServices.VideoPublishingComponent.Handlers.Commands

  # TODO: Support multiple handlers for a single consumer

  @impl true
  def handle_message(command) do
    Commands.PublishVideoHandler.handle_message(command)
    Commands.NameVideoHandler.handle_message(command)
  end
end
