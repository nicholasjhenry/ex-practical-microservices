defmodule VideoTutorialsServices.Emailer.Client do
  use Verity.Client

  export(VideoTutorialsServices.EmailerComponent.Messages, as: Messages)
end
