defmodule VideoTutorialsBackOfficeWeb.StreamLive.Index do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    streams = VideoTutorialsBackOffice.list_streams()
    {:noreply, assign(socket, streams: streams)}
  end
end
