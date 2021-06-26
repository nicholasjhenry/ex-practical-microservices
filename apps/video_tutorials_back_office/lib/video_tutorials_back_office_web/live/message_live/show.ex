defmodule VideoTutorialsBackOfficeWeb.MessageLive.Show do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:message, VideoTutorialsBackOffice.get_message!(id))}
  end
end
