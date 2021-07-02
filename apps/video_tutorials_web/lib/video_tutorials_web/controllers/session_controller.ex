defmodule VideoTutorialsWeb.SessionController do
  use VideoTutorialsWeb, :controller

  alias VideoTutorials.Authentication

  def create(conn, %{"token" => token} = params) do
    case Authentication.verify(VideoTutorialsWeb.Endpoint, token) do
      {:ok, user_id} ->
        conn
        |> Authentication.login(user_id)
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        create(conn, params)
    end
  end

  def create(conn, _params) do
    conn
    |> put_flash(:error, "error")
    |> redirect(to: Routes.authenticate_path(conn, :index))
  end

  def delete(conn, _params) do
    conn
    |> clear_session
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
