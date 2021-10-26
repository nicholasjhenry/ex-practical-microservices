defmodule VideoTutorialsServices.EmailerComponent do
  alias VideoTutorialsServices.EmailerComponent.Consumers

  def child_specs do
    [Consumers.Commands.child_spec(stream_name: "sendEmail:command")]
  end
end
