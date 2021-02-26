defmodule VideoTutorialsBackOffice do
  @moduledoc """
  VideoTutorialsBackOffice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias VideoTutorialsData.Repo

  defmodule Message do
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

  import Ecto.Query, only: [from: 2]

  def list_messages do
    query = from(messages in Message, order_by: messages.global_position)
    Repo.all(query)
  end
end
