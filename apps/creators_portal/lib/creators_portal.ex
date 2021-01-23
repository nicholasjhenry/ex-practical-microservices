defmodule CreatorsPortal do
  @moduledoc """
  CreatorsPortal keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias CreatorsPortal.Video
  alias VideoTutorials.Repo

  require Ecto.Query

  def dashboard(owner_id) do

    Video
    |> by_owner_id(owner_id)
    |> Repo.all()
  end

  defp by_owner_id(query, owner_id) do
    import Ecto.Query

    from(videos in query, where: videos.owner_id == ^owner_id)
  end
end
