defmodule VideoTutorialsServices.IdentityComponent do
  alias VideoTutorialsServices.IdentityComponent.Consumers

  def child_specs do
    [
      Consumers.Commands,
      Consumers.Events,
      Consumers.Events.Emailer
    ]
  end
end
