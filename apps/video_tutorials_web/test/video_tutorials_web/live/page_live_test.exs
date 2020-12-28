defmodule VideoTutorialsWeb.PageLiveTest do
  use VideoTutorialsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorials.Page

  setup do
    VideoTutorials.Repo.insert!(%Page{name: "home", data: %{"videos_watched" => 5, "last_view_processed" => 10}})

    :ok
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Viewers have watched 5 video(s)"
    assert render(page_live) =~ "Viewers have watched 5 video(s)"
  end

  test "record viewing a video", %{conn: conn} do
    {:ok, page_live, _} = live(conn, "/")

    html =
      page_live
      |> form("#video-form")
      |> render_submit()

    assert html =~ "Video viewing recorded (123)"
    message = MessageStore.read_last_message("viewing-123")
    assert message.type == "VideoViewed"
  end
end
