defmodule VideoTutorialsBackOfficeWeb.UserLive.IndexTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsData.AdminUser

  test "disconnected and connected render", %{conn: conn} do
    user = Repo.insert!(%AdminUser{email: "jane@example.com"})

    {:ok, user_live, disconnected_html} = live(conn, "/admin/users")
    assert disconnected_html =~ "Users"

    render(user_live)
    |> assert_html("h1", "Users")
    |> assert_html("[data-user=id] a", text: user.id)
  end
end
