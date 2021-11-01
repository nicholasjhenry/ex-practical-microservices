defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.PublishVideo do
  use Verity.Messaging.Message

  attributes [:video_id, :owner_id, :source_uri]
end
