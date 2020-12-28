defmodule VideoTutorialsWeb.PageLive do
  use VideoTutorialsWeb, :live_view

  alias VideoTutorials.HomePage

  @impl true
  def mount(_params, _session, socket) do
    page = HomePage.load_home_page()

    {:ok, assign(socket, videos_watched: page.data["videos_watched"])}
  end
end
