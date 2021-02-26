defmodule VideoTutorialsBackOfficeWeb.MessageLive.Index do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    messages = VideoTutorialsBackOffice.list_messages()
    {:ok, assign(socket, messages: messages)}
  end
end
