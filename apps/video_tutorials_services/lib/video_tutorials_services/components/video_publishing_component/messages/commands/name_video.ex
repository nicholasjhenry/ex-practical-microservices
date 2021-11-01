defmodule VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.NameVideo do
  use Verity.Messaging.Message

  defstruct [:metadata, :video_id, :name]
end
