defmodule VideoTutorialsWeb.PageLive do
  use VideoTutorialsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, videos_watched: 1)}
  end
end
