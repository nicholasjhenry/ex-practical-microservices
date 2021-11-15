defmodule CreatorsPortal do
  @moduledoc """
  CreatorsPortal keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query
  import Verity.Messaging.StreamName
  import Verity.Messaging.Write
  import Verity.Client

  alias VideoTutorialsData.{Repo, Video, VideoOperation}

  include(VideoTutorialsServices.VideoPublishing.Client, alias: NameVideo)
  include(VideoTutorialsServices.VideoPublishing.Client, alias: PublishVideo)

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
    Ecto.Changeset.change(video, %{id: UUID.uuid4()})
  end

  def publish_video(context, attrs) do
    data = %{}
    types = %{file: :string, id: :string, owner_id: :string}

    result =
      {data, types}
      |> Ecto.Changeset.cast(attrs, Map.keys(types))
      |> Ecto.Changeset.validate_required(Map.keys(types))
      |> Ecto.Changeset.apply_action(:validated)

    with {:ok, data} <- result do
      stream_name = command_stream_name(data.id, :videoPublishing)

      command =
        PublishVideo.build(
          %{
            trace_id: context.trace_id,
            user_id: context.user_id
          },
          %{
            owner_id: data.owner_id,
            source_uri: data.file,
            video_id: data.id
          }
        )

      write(command, stream_name)

      {:ok, data}
    end
  end

  def name_video(context, video, %{"name" => name}) do
    stream_name = command_stream_name(video.id, :videoPublishing)

    command =
      NameVideo.build(
        %{
          trace_id: context.trace_id,
          user_id: context.user_id,
          origin_stream_name: nil
        },
        %{
          name: name,
          video_id: video.id
        }
      )

    write(command, stream_name)

    {:ok, video}
  end

  def get_video_operation_by_trace_id(trace_id) do
    Repo.get_by(VideoOperation, trace_id: trace_id)
  end
end
