defmodule VideoTutorialsServices.EmailerComponent do
  alias VideoTutorialsServices.EmailerComponent.Consumers

  def child_specs do
    Consumers.Commands.child_specs()
  end
end
