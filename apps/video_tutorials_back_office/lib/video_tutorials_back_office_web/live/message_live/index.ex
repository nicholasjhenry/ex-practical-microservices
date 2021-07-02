defmodule VideoTutorialsBackOfficeWeb.MessageLive.Index do
  use VideoTutorialsBackOfficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"type" => type}, _session, socket) do
    messages = VideoTutorialsBackOffice.list_messages(%{type: type})
    {:noreply, assign(socket, messages: messages)}
  end

  def handle_params(%{"trace_id" => trace_id}, _session, socket) do
    messages = VideoTutorialsBackOffice.list_messages(%{trace_id: trace_id})
    {:noreply, assign(socket, messages: messages)}
  end

  def handle_params(_params, _session, socket) do
    messages = VideoTutorialsBackOffice.list_messages()
    {:noreply, assign(socket, messages: messages)}
  end
end
