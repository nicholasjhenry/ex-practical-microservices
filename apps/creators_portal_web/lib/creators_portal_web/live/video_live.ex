defmodule CreatorsPortalWeb.VideoLive do
  use CreatorsPortalWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    video = CreatorsPortal.get_video!(id)
    {:noreply,
     socket
     |> assign(:video, video)
     |> assign(:changeset, CreatorsPortal.change_video(video))}
  end

  @impl true
  def handle_event("name_video", %{"video" => video_params}, socket) do
    name_video(socket, video_params)
  end

  def name_video(socket, video_params) do
    case CreatorsPortal.name_video(socket.assigns.video, video_params) do
      {:ok, _video} ->
        {:noreply,
         socket
         |> put_flash(:info, "Video named pending")
         |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
