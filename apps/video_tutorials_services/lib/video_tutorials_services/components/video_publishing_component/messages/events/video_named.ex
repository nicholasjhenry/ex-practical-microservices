defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed do
  use Verity.Messaging.Message

  attributes [:name]
end
