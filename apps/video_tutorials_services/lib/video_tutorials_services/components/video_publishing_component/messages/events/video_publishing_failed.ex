defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublishingFailed do
  use Verity.Messaging.Message

  defstruct [:metadata, :video_id, :owner_id, :source_uri, :reason]
end
