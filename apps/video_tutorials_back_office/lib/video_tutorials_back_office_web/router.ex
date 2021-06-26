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

  scope "/admin", VideoTutorialsBackOfficeWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/messages", MessageLive.Index, :index
    live "/messages/:id", MessageLive.Show, :show
    live "/streams", StreamLive.Index, :index
    live "/subscriber_positions", SubscriberPositionLive.Index, :index
    live "/users", UserLive.Index, :index
    live "/users/:id", UserLive.Show, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", VideoTutorialsBackOfficeWeb do
  #   pipe_through :api
  # end
end
