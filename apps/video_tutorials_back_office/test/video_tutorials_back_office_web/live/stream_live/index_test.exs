defmodule VideoTutorialsBackOfficeWeb.StreamLive.IndexTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsData.AdminStream

  test "disconnected and connected render", %{conn: conn} do
    stream = Repo.insert!(%AdminStream{stream_name: "test-stream"})

    {:ok, page_live, disconnected_html} = live(conn, "/admin/streams")
    assert disconnected_html =~ "Streams"

    render(page_live)
    |> assert_html("h1", "Streams")
    |> assert_html("[data-stream=stream-name] a", text: stream.stream_name)
  end
end
