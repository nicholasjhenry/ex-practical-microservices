defmodule CreatorsPortal do
  @moduledoc """
  CreatorsPortal keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query

  alias VideoTutorialsData.{Repo, Video, VideoOperation}

  def dashboard(owner_id) do
    Video
    |> by_owner_id(owner_id)
    |> Repo.all()
  end

  defp by_owner_id(query, owner_id) do
    from(videos in query, where: videos.owner_id == ^owner_id)
  end

  def get_video!(id), do: Repo.get!(Video, id)

  def change_video(%Video{} = video, _attrs \\ %{}) do
    Ecto.Changeset.change(video)
  end

  def name_video(context, video, attrs) do
    stream_name = "videoPublishing:command-#{video.id}"

    command = MessageStore.NewMessage.new(
      stream_name: stream_name,
      type: "NameVideo",
      metadata: %{
        trace_id: context.trace_id,
        user_id: context.user_id
      },
      data: %{
        name: attrs["name"],
        video_id: video.id,
      },
      expected_version: nil
    )

    MessageStore.write_message(command)

    {:ok, video}
  end

  def get_video_operation_by_trace_id(trace_id) do
    Repo.get_by(VideoOperation, trace_id: trace_id)
  end
end
