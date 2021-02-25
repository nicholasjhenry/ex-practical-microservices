defmodule VideoTutorialsData.Video do
  use VideoTutorialsData.Schema

  schema "creators_portal_videos" do
    field :owner_id, :binary_id
    field :name, :string
    field :description, :string
    field :views, :integer
    field :source_uri, :string
    field :transcoded_uri, :string
    field :position, :integer
  end
end
