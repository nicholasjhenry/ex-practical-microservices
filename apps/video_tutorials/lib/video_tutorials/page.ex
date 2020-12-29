defmodule VideoTutorials.Page do
  use VideoTutorials.Schema

  schema "pages" do
    field :name, :string
    field :data, :map
  end
end
