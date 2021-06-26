defmodule VideoTutorialsBackOfficeWeb.MessageLive.IndexTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsBackOffice.Message

  test "disconnected and connected render", %{conn: conn} do
    message = Repo.insert!(%Message{stream_name: "test-stream", type: "test_type", position: 0})

    {:ok, page_live, disconnected_html} = live(conn, "/admin/messages")
    assert disconnected_html =~ "Messages"

    render(page_live)
    |> assert_html("h1", "Messages")
    |> assert_html("[data-message=id] a", text: message.id)
  end

  test "render with message type", %{conn: conn} do
    message = Repo.insert!(%Message{stream_name: "test-stream", type: "test_type", position: 0})

    {:ok, page_live, disconnected_html} =
      conn
      |> live("/admin/messages?type=test_type")

    assert disconnected_html =~ "Messages"

    render(page_live)
    |> assert_html("h1", "Messages")
    |> assert_html("[data-message=id] a", text: message.id)
  end

  test "render with message correlation", %{conn: conn} do
    trace_id = Ecto.UUID.generate()
    message = Repo.insert!(%Message{stream_name: "test-stream", type: "test_type", position: 0, metadata: %{trace_id: trace_id}})
    _not_correlated_message = Repo.insert!(%Message{stream_name: "another-stream", type: "test_type", position: 0})

    {:ok, page_live, disconnected_html} =
      conn
      |> live("/admin/messages?trace_id=#{trace_id}")

    assert disconnected_html =~ "Messages"

    render(page_live)
    |> assert_html("h1", "Messages")
    |> assert_html("[data-message=id] a", text: message.id)
  end
end
