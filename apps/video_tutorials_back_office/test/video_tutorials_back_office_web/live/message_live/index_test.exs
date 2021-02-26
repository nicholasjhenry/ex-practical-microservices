defmodule VideoTutorialsBackOfficeWeb.MessageLive.IndexTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/admin/messages")
    assert disconnected_html =~ "Messages"
    assert render(page_live) =~ "Messages"
  end
end
