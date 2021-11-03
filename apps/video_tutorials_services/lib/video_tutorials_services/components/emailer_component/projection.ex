defmodule VideoTutorialsServices.EmailerComponent.Projection do
  use Verity.EntityProjection

  alias VideoTutorialsServices.EmailerComponent.Emailer
  alias VideoTutorialsServices.EmailerComponent.Messages.Events.Sent

  @impl true
  def init(), do: %Emailer{}

  @impl true
  def apply(email, %Sent{} = _command) do
    %{email | sent?: true}
  end
end
