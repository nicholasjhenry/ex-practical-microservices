defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed do
  use Verity.Messaging.Message

  attributes [:video_id, :owner_id, :source_uri, :reason]
end
