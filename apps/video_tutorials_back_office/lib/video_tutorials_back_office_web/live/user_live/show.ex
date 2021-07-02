defmodule VideoTutorialsBackOfficeWeb.UserLive.Show do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:user, VideoTutorialsBackOffice.get_user!(id))
     |> assign(
       :viewing_activity,
       VideoTutorialsBackOffice.list_messages(category: "viewing", user_id: id)
     )
     |> assign(
       :login_activity,
       VideoTutorialsBackOffice.list_messages(stream_name: "authentication-#{id}")
     )}
  end
end
