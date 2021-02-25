defmodule VideoTutorialsBackOfficeWeb.Router do
  use VideoTutorialsBackOfficeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VideoTutorialsBackOfficeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VideoTutorialsBackOfficeWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", VideoTutorialsBackOfficeWeb do
  #   pipe_through :api
  # end
end
