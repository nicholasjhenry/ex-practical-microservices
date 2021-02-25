defmodule VideoTutorials.Login do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  def changeset(login, attrs) do
    login
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end
end
