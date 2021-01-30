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
     |> assign(:changeset, CreatorsPortal.change_video(video))}
  end
end
