defmodule CreatorsPortalWeb.VideoOperationLiveTest do
  use CreatorsPortalWeb.ConnCase

  import Phoenix.LiveViewTest

  alias VideoTutorialsData.VideoOperation

  describe "disconnected and connected render" do
    test "video operation pending", %{conn: conn} do
      {:ok, video_live, disconnected_html} =
        live(conn, Routes.video_operation_path(conn, :show, 1, mode: "manual"))

      assert disconnected_html =~ "Operation pending"
      assert render(video_live) =~ "Operation pending"
    end

    test "video operation failed", %{conn: conn} do
      [video_operation: video_operation] = insert_failed_video_operation()

      {:ok, video_live, disconnected_html} =
        live(
          Plug.Conn.assign(conn, :foo, :bar),
          Routes.video_operation_path(conn, :show, video_operation.trace_id, mode: "manual")
        )

      assert disconnected_html =~ "Operation failed"
      assert render(video_live) =~ "Operation failed"
    end
  end

  describe "handle tick" do
    test "video operation pending", %{conn: conn} do
      {:ok, video_live, _html} =
        live(
          conn,
          Routes.video_operation_path(conn, :show, "7682F3EB-65DF-4ABF-87E3-0F1143A67457",
            mode: "manual"
          )
        )

      send(video_live.pid, :tick)

      assert render(video_live) =~ "Operation pending"
    end

    test "video operation completed", %{conn: conn} do
      {:ok, video_live, _html} =
        live(
          conn,
          Routes.video_operation_path(conn, :show, "7682F3EB-65DF-4ABF-87E3-0F1143A67457",
            mode: "manual"
          )
        )

      [video_operation: video_operation] = insert_completed_video_operation()

      send(video_live.pid, :tick)

      assert_redirect(video_live, Routes.video_path(conn, :edit, video_operation.video_id))
    end

    test "video operation failed", %{conn: conn} do
      {:ok, video_live, _html} =
        live(
          conn,
          Routes.video_operation_path(conn, :show, "7682F3EB-65DF-4ABF-87E3-0F1143A67457",
            mode: "manual"
          )
        )

      [video_operation: _video_operation] = insert_failed_video_operation()

      send(video_live.pid, :tick)

      assert render(video_live) =~ "Operation failed"
    end
  end

  def insert_failed_video_operation(_context \\ %{}) do
    video_operation =
      %VideoOperation{
        video_id: "1F2D2A6F-47DB-477F-9C48-7A706AF3A038",
        trace_id: "7682F3EB-65DF-4ABF-87E3-0F1143A67457",
        succeeded: false,
        failure_reason: %{message: "Unknown Error"}
      }
      |> Repo.insert!()

    [video_operation: video_operation]
  end

  def insert_completed_video_operation(_context \\ %{}) do
    video_operation =
      %VideoOperation{
        video_id: "1F2D2A6F-47DB-477F-9C48-7A706AF3A038",
        trace_id: "7682F3EB-65DF-4ABF-87E3-0F1143A67457",
        succeeded: true
      }
      |> Repo.insert!()

    [video_operation: video_operation]
  end
end
