defmodule VideoTutorialsServices.EmailerComponent.Consumers.Commands do
  alias VideoTutorialsServices.EmailerComponent.Handlers

  use Verity.Consumer, handler: Handlers.Commands
end
