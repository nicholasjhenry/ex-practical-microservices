defmodule CreatorsPortal.Video do
  use CreatorsPortal.Schema

  schema "creators_portal_videos" do
    field :owner_id, :binary
    field :name, :string
    field :description, :string
    field :views, :integer
    field :source_uri, :string
    field :transcoded_uri, :string
  end
end
