defmodule VideoTutorialsWeb.PageLive do
  use VideoTutorialsWeb, :live_view

  alias VideoTutorials.HomePage

  @impl true
  def mount(_params, _session, socket) do
    page = HomePage.load_home_page()

    {:ok, assign(socket, videos_watched: page.data["videos_watched"])}
  end

  @impl true
  def handle_event("record_viewing_video", %{"video" => video_params}, socket) do
    record_viewing_video(socket, video_params)
  end

  defp record_viewing_video(socket, %{"id" => video_id}) do
    :ok = VideoTutorials.RecordViewings.record_viewing(0, video_id, 0)

    {:noreply, put_flash(socket, :info, "Video viewing recorded (123)")}
  end
end
