defmodule VideoTutorialsServices.EmailerComponent.Consumers.Commands do
  alias VideoTutorialsServices.EmailerComponent.Handlers

  use Verity.Consumer, handlers: Handlers.Commands
end
