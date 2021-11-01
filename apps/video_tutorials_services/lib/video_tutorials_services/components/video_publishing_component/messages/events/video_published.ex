defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoPublished do
  use Verity.Messaging.Message

  defstruct [:metadata, :owner_id, :source_uri, :transcoded_uri, :video_id]
end
