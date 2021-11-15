defmodule CreatorsPortalTest do
  use CreatorsPortal.DataCase

  alias VideoTutorialsData.Video

  describe "naming a video" do
    test "queues a command to name a video" do
      video = insert_video()
      params = %{"name" => "Rick Astley"}
      context = %{trace_id: UUID.uuid4(), user_id: UUID.uuid4()}

      assert {:ok, _video} = CreatorsPortal.name_video(context, video, params)
    end
  end

  def insert_video() do
    Repo.insert!(%Video{
      owner_id: Ecto.UUID.generate(),
      name: "Unknown",
      description: "Unknown",
      source_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA",
      transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA"
    })
  end
end
