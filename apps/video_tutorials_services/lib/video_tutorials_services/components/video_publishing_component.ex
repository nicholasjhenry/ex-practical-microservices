defmodule VideoTutorialsServices.VideoPublishingComponent do
  alias VideoTutorialsServices.VideoPublishingComponent.Consumers

  def child_specs do
    Consumers.Commands.child_specs()
  end
end
