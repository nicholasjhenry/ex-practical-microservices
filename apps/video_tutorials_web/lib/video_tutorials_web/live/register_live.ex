defmodule VideoTutorialsWeb.RegisterLive do
  use VideoTutorialsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: nil)}
  end

  @impl true
  def handle_event("register_user", params, socket) do
    register_user(socket, params)
  end

  def register_user(socket, _params) do
    {:noreply,
      socket
      |> put_flash(:info, "You have successfully registered!")
      |> push_redirect(to: Routes.completed_registration_path(socket, :show))
    }
  end
end
