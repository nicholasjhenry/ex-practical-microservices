defmodule VideoTutorialsServices.EmailerComponent.Projection do
  alias VideoTutorialsServices.EmailerComponent.Emailer

  def init() do
    %Emailer{}
  end

  def apply(email, %{type: "Sent"}) do
    Map.put(email, :sent?, true)
  end
end
