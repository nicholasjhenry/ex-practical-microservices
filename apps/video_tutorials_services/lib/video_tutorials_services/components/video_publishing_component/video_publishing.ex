defmodule VideoTutorialsServices.VideoPublishingComponent.VideoPublishing do
  defstruct [
    :id,
    :publishing_attempted?,
    :source_uri,
    :transcoded_uri,
    :owner_id,
    :sequence,
    :name
  ]

  def changeset(video, data) do
    import Ecto.Changeset

    types = %{name: :string}

    {video, types}
    |> cast(%{name: data["name"]}, Map.keys(types))
    |> validate_required(~w/name/a)
    |> apply_action(:insert)
  end
end
