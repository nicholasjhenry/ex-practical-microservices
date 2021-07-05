defmodule VideoTutorialsWeb.RegisterLive do
  use VideoTutorialsWeb, :live_view

  alias VideoTutorials.Registration

  @impl true
  def mount(_params, _session, socket) do
    changeset = Registration.change_registration(%Registration{id: UUID.uuid4()})
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate_registration", %{"registration" => registration_params}, socket) do
    changeset =
      %Registration{}
      |> Registration.change_registration(registration_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("register_user", %{"registration" => registration_params}, socket) do
    register_user(socket, registration_params)
  end

  def register_user(socket, params) do
    case Registration.register_user(params) do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "You have successfully registered!")
         |> push_redirect(to: Routes.completed_registration_path(socket, :show))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
