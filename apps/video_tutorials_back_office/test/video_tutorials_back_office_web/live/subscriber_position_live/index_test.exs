defmodule VideoTutorialsBackOfficeWeb.SubscriberPositionLive.IndexTest do
  use VideoTutorialsBackOfficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsData.AdminSubscriberPosition

  test "disconnected and connected render", %{conn: conn} do
    position = Repo.insert!(%AdminSubscriberPosition{subscriber_id: "foo"})

    {:ok, page_live, disconnected_html} = live(conn, "/admin/subscriber_positions")
    assert disconnected_html =~ "Component Read Positions"

    render(page_live)
    |> assert_html("h1", "Component Read Positions")
    |> assert_html("[data-subscriber-position=subscriber-id] a", text: position.subscriber_id)
  end
end
