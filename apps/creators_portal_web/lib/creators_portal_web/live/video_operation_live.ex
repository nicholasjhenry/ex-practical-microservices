defmodule CreatorsPortalWeb.VideoOperationLive do
  use CreatorsPortalWeb, :live_view

  @impl true
  def mount(%{"trace_id" => trace_id} = params, _session, socket) do
    mode = params["mode"] || "auto"
    if connected?(socket), do: tick(mode)

    video_operation = CreatorsPortal.get_video_operation_by_trace_id(trace_id)

    timestamp = DateTime.utc_now()

    {:ok,
     socket
     |> assign(
       timestamp: to_string(timestamp),
       mode: mode,
       trace_id: trace_id,
       video_operation: video_operation,
       pending?: is_nil(video_operation)
     )}
  end

  @impl true
  def handle_info(:tick, socket) do
    video_operation = CreatorsPortal.get_video_operation_by_trace_id(socket.assigns.trace_id)

    if video_operation && video_operation.succeeded do
      {:noreply,
       socket
       |> push_redirect(to: Routes.video_path(socket, :edit, video_operation.video_id))}
    else
      tick(socket.assigns.mode)
      timestamp = DateTime.utc_now()

      {:noreply,
       socket
       |> assign(
         timestamp: timestamp,
         video_operation: video_operation,
         pending?: is_nil(video_operation)
       )}
    end
  end

  def tick(mode) do
    if mode == "auto" do
      Process.send_after(self(), :tick, 1000)
    end
  end
end
