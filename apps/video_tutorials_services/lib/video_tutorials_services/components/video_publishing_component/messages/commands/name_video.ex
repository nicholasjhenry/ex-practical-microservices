defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.NameVideo do
  use Verity.Messaging.Message

  attributes [:video_id, :name]
end
