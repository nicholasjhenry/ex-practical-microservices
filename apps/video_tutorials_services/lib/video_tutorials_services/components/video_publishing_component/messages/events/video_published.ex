defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished do
  use Verity.Messaging.Message

  attributes [:owner_id, :source_uri, :transcoded_uri, :video_id]
end
