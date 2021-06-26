defmodule VideoTutorialsBackOfficeWeb.UserLive.ShowTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsData.AdminUser

  test "disconnected and connected render", %{conn: conn} do
    user = Repo.insert!(%AdminUser{email: "jane@example.com"})

    {:ok, page_live, disconnected_html} = live(conn, "/admin/users/#{user.id}")
    assert disconnected_html =~ user.id
    assert render(page_live) =~ user.id
  end
end
