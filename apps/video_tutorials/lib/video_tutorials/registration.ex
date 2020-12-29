defmodule VideoTutorials.Registration do
  use VideoTutorials.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:id, :email, :password])
    |> validate_required([:id, :email, :password])
    |> validate_length(:password, min: 6)
  end
end
