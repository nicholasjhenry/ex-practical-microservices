defmodule VideoTutorialsBackOfficeWeb.MessageLive.ShowTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsBackOffice.Message

  test "disconnected and connected render", %{conn: conn} do
    message = Repo.insert!(%Message{stream_name: "testStream", type: "test_type", position: 0})

    {:ok, page_live, disconnected_html} = live(conn, "/admin/messages/#{message.id}")
    assert disconnected_html =~ message.id
    assert render(page_live) =~ message.id
  end
end
