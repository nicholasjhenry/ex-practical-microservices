defmodule VideoTutorials.Identity do
  defstruct [:id, :email, :registered?]

  def init do
    %__MODULE__{registered?: false}
  end

  def apply(identity, %{type: "Registered", data: data}) do
    %{identity | id: data["id"], email: data["email"], registered?: true}
  end
end
