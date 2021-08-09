defmodule CreatorsPortalWeb.PageLive do
  use CreatorsPortalWeb, :live_view

  alias VideoTutorialsData.Video

  @owner_id "1F2D2A6F-47DB-477F-9C48-7A706AF3A038"

  @impl true
  def mount(_params, _session, socket) do
    videos = CreatorsPortal.dashboard(@owner_id)
    changeset = CreatorsPortal.change_video(%Video{})

    {:ok,
     socket
     |> allow_upload(:file, accept: ~w(.mov), max_entries: 1)
     |> assign(query: "", videos: videos, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"video" => _video_params}, socket) do
    changeset =
      %Video{}
      |> CreatorsPortal.change_video()
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("publish_video", %{"video" => video_params}, socket) do
    context = %{trace_id: video_params["trace_id"] || UUID.uuid4(), user_id: UUID.uuid4()}

    video_params =
      video_params
      |> Map.put("owner_id", @owner_id)
      |> Map.put("file", get_upload_client_name(socket))

    case CreatorsPortal.publish_video(context, video_params) do
      {:ok, _video} ->
        {:noreply,
         socket
         |> put_flash(:info, "Video published successfully")
         |> push_redirect(to: Routes.page_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def get_upload_client_name(socket) do
    case uploaded_entries(socket, :file) do
      {[upload], _} ->
        upload.client_name

      _ ->
        nil
    end
  end
end
