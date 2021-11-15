defmodule VideoTutorialsServices.Identity.Client do
  use Verity.Client

  export(VideoTutorialsServices.IdentityComponent.Messages.Commands.Register, as: Register)
end
