defmodule VideoTutorialsServices.IdentityComponent do
  alias VideoTutorialsServices.IdentityComponent.Consumers

  def child_specs do
    [
      Consumers.Commands.child_spec(stream_mame: "identity:command"),
      Consumers.Events.child_spec(stream_mame: "identity"),
      Consumers.Events.Emailer.child_spec(stream_name: "sendEmail")
    ]
  end
end
