defmodule VideoTutorialsWeb.AuthenticateLive do
  use VideoTutorialsWeb, :live_view

  alias VideoTutorials.{Authentication, Login}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: Authentication.change_login(%Login{}))}
  end

  @impl true
  def handle_event("validate_login", %{"login" => login_params}, socket) do
    changeset =
      %Login{}
      |> Authentication.change_login(login_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("login", %{"login" => login_params}, socket) do
    authenticate(socket, login_params)
  end

  def authenticate(socket, params) do
    case Authentication.authenticate(VideoTutorialsWeb.Endpoint, params) do
      {:ok, token} ->
        {:noreply, redirect(socket, to: Routes.session_path(socket, :create, %{token: token}))}
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Login failed!") }
    end
  end
end
