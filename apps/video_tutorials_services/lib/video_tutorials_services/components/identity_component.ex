defmodule VideoTutorialsServices.IdentityComponent do
  alias VideoTutorialsServices.IdentityComponent.Consumers

  def child_specs do
    [
      Consumers.Commands.child_spec(),
      Consumers.Events.child_spec(),
      Consumers.Events.Emailer.child_spec()
    ]
  end
end
