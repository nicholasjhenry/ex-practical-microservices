defmodule VideoTutorialsData.Page do
  use VideoTutorialsData.Schema

  schema "pages" do
    field :name, :string
    field :data, :map
  end
end
