defmodule VideoTutorialsServices.EmailerComponent.Projection do
  use Verity.EntityProjection

  alias VideoTutorialsServices.EmailerComponent.Emailer

  @impl true
  def init(), do: %Emailer{}

  @impl true
  def apply(email, %{type: "Sent"}) do
    Map.put(email, :sent?, true)
  end
end
