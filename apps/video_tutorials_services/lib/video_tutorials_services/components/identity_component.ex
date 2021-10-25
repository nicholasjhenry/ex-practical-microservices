defmodule VideoTutorialsServices.IdentityComponent do
  alias VideoTutorialsServices.IdentityComponent.Consumers

  def child_specs do
    Consumers.Commands.child_specs() ++
      Consumers.Events.child_specs() ++
      Consumers.Events.Emailer.child_specs()
  end
end
