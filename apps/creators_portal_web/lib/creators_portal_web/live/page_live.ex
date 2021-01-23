defmodule CreatorsPortalWeb.PageLive do
  use CreatorsPortalWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", videos: [])}
  end
end
