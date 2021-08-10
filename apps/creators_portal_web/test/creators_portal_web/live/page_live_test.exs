defmodule CreatorsPortalWeb.PageLiveTest do
  use CreatorsPortalWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, Routes.page_path(conn, :index))
    assert disconnected_html =~ "Creators Portal"
    assert render(page_live) =~ "Creators Portal"
  end

  test "publish new video", %{conn: conn} do
    {:ok, index_live, _html} = live(conn, Routes.page_path(conn, :index))

    assert index_live
           |> form("#video-form")
           |> render_submit() =~ "can&apos;t be blank"

    video =
      file_input(index_live, "#video-form", :file, [
        %{
          last_modified: 1_594_171_879_000,
          name: "foo.mov",
          content: File.read!("./test/fixtures/foo.mov"),
          size: 1_396_009,
          type: "video/quicktime"
        }
      ])

    assert render_upload(video, "foo.mov") =~ ~s(<progress max="100" value="100"></progress>)

    {:ok, _, html} =
      index_live
      |> form("#video-form")
      |> render_submit()
      |> follow_redirect(conn, Routes.page_path(conn, :index))

    assert html =~ "Video published successfully"
  end
end
