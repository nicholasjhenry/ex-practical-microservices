defmodule VideoTutorialsData.AdminStream do
  use VideoTutorialsData.Schema

  @primary_key false

  schema "admin_streams" do
    field :stream_name, :string, primary_key: true
    field :message_count, :integer
    field :last_message_id, :binary_id
    field :last_message_global_position, :integer
  end
end
