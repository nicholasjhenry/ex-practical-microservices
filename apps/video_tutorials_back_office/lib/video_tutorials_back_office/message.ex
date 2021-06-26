defmodule VideoTutorialsBackOffice.Message do
  use Ecto.Schema
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @schema_prefix "message_store"

  schema "messages" do
    field :stream_name, :string
    field :type, :string
    field :position, :integer
    field :global_position, :integer
    field :data, :map
    field :metadata, :map
    field :time, :utc_datetime
  end
end
