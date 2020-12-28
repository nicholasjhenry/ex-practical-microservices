defmodule VideoTutorialsWeb.PageLive do
  use VideoTutorialsWeb, :live_view

  alias VideoTutorials.HomePage

  @impl true
  def mount(_params, _session, socket) do
    page = HomePage.load_home_page()

    {:ok, assign(socket, videos_watched: page.data["videos_watched"])}
  end

  @impl true
  def handle_event("record_viewing_video", _params, socket) do
    record_viewing_video(socket)
  end

  defp record_viewing_video(socket) do
    {:noreply, put_flash(socket, :info, "Video viewing recorded")}
  end
end
