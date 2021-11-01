defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNameRejected do
  use Verity.Messaging.Message

  attributes [:name, :reason]
end
