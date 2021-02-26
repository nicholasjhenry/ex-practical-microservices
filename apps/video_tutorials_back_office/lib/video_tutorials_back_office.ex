defmodule VideoTutorialsBackOffice do
  @moduledoc """
  VideoTutorialsBackOffice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias VideoTutorialsBackOffice.Message
  alias VideoTutorialsData.Repo

  import Ecto.Query, only: [from: 2]

  def list_messages do
    query = from(messages in Message, order_by: messages.global_position)
    Repo.all(query)
  end

  def get_message!(id) do
    Repo.get!(Message, id)
  end
end
