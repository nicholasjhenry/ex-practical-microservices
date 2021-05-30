defmodule VideoTutorialsBackOfficeWeb.UserLive.Index do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    users = VideoTutorialsBackOffice.list_users()
    {:noreply, assign(socket, users: users)}
  end
end
