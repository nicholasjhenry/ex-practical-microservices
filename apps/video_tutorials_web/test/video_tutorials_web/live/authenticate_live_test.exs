defmodule VideoTutorialsWeb.AuthenticateLiveTest do
  use VideoTutorialsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsData.{Page, UserCredential}
  alias VideoTutorials.Password

  setup do
    Repo.insert!(%Page{name: "home", data: %{"videos_watched" => 5, "last_view_processed" => 10}})
    password_hash = Password.hash("test")
    Repo.insert!(%UserCredential{email: "jane@example.com", password_hash: password_hash})

    :ok
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, register_live, disconnected_html} = live(conn, "/auth/log-in")
    assert disconnected_html =~ "Log in"
    assert render(register_live) =~ "Log in"
  end

  test "logging in a user", %{conn: conn} do
    {:ok, register_live, _} = live(conn, "/auth/log-in")

    assert register_live
           |> form("#login-form", login: %{})
           |> render_change() =~ "can&apos;t be blank"

    valid_attrs = %{email: "jane@example.com", password: "test"}

    {:ok, conn} =
      register_live
      |> form("#login-form", login: valid_attrs)
      |> render_submit()
      |> follow_redirect(conn)

    assert html_response(conn, 302)
  end
end
