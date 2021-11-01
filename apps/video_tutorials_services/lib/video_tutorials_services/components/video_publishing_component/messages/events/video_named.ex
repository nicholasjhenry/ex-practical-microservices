defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Events.VideoNamed do
  use Verity.Messaging.Message

  defstruct [:metadata, :name]
end
