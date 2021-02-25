defmodule VideoTutorialsBackOfficeWeb.PageControllerTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/admin")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
