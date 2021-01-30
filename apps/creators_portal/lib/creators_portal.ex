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

  def get_video!(id), do: Repo.get!(Video, id)

  def change_video(%Video{} = video, _attrs \\ %{}) do
    Ecto.Changeset.change(video)
  end

  def name_video(video, _attrs) do
    {:ok, video}
  end
end
