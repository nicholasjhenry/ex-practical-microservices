defmodule VideoTutorialsBackOfficeWeb.SubscriberPositionLive.Index do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    subscriber_positions = VideoTutorialsBackOffice.list_subscriber_positions()
    {:noreply, assign(socket, subscriber_positions: subscriber_positions)}
  end
end
