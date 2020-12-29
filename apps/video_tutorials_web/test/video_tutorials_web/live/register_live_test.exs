defmodule VideoTutorialsWeb.RegisterLiveTest do
  use VideoTutorialsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, register_live, disconnected_html} = live(conn, "/register")
    assert disconnected_html =~ "Register User"
    assert render(register_live) =~ "Register User"
  end

  test "registering a user", %{conn: conn} do
    {:ok, register_live, _} = live(conn, "/register")

    assert register_live
      |> form("#registration-form", registration: %{})
      |> render_change() =~ "can&apos;t be blank"


    valid_attrs = %{email: "jane@example.com", password: "abc123#"}

    {:ok, _, html} =
      register_live
      |> form("#registration-form", registration: valid_attrs)
      |> render_submit()
      |> follow_redirect(conn, Routes.completed_registration_path(conn, :show))

    assert html =~ "You have successfully registered!"
  end
end
