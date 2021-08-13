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
end
