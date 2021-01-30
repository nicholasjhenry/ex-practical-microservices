defmodule CreatorsPortalWeb.VideoLiveTest do
  use CreatorsPortalWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :create_video

  test "disconnected and connected render", %{conn: conn, video: video} do
    {:ok, video_live, disconnected_html} = live(conn, "/video/#{video.id}/edit")
    assert disconnected_html =~ "Video Name"
    assert render(video_live) =~ "Video Name"
  end

  def create_video(_context) do
    video = %CreatorsPortal.Video{
      owner_id: "1F2D2A6F-47DB-477F-9C48-7A706AF3A038",
      name: "Untitled",
      description: "Example",
      source_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA",
      transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA"
    } |> VideoTutorials.Repo.insert!

    [video: video]
  end
end
