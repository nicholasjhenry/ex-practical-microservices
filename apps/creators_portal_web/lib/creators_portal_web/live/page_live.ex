defmodule CreatorsPortalWeb.PageLive do
  use CreatorsPortalWeb, :live_view

  @owner_id "1F2D2A6F-47DB-477F-9C48-7A706AF3A038"

  @impl true
  def mount(_params, _session, socket) do
    videos = CreatorsPortal.dashboard(@owner_id)
    {:ok, assign(socket, query: "", videos: videos)}
  end
end
