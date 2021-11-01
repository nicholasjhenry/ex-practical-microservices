defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected do
  use Verity.Messaging.Message

  defstruct [:metadata, :name, :reason]
end
