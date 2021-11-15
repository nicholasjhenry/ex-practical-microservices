defmodule VideoTutorialsServices.VideoPublishing.Client do
  use Verity.Client

  export(VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.NameVideo,
    as: NameVideo
  )

  export(VideoTutorialsServices.VideoPublishingComponent.Messages.Commands.PublishVideo,
    as: PublishVideo
  )
end
