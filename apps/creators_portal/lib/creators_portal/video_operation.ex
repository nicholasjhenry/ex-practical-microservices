defmodule CreatorsPortal.VideoOperation do
  use CreatorsPortal.Schema

  schema "creators_portal_video_operations" do
    field :video_id, :binary
    field :trace_id, :string
    field :succeeded, :boolean
    field :failure_reason, :map
  end
end
