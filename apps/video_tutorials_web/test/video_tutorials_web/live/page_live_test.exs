defmodule VideoTutorialsWeb.PageLiveTest do
  use VideoTutorialsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "This is the home page"
    assert render(page_live) =~ "This is the home page"
  end
end
