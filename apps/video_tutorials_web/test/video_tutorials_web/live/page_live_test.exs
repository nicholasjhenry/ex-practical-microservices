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
end
