defmodule VideoTutorialsServices.IdentityComponent do
  alias VideoTutorialsServices.IdentityComponent.Consumers

  def child_specs do
    [
      Consumers.Commands.child_spec(stream_name: "identity:command"),
      Consumers.Events.child_spec(stream_name: "identity"),
      Consumers.Events.SendEmail.child_spec(stream_name: "sendEmail")
    ]
  end
end
