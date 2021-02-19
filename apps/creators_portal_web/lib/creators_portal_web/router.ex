defmodule CreatorsPortalWeb.Router do
  use CreatorsPortalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CreatorsPortalWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CreatorsPortalWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/video/:id/edit", VideoLive, :edit
    live "/video_operation/:trace_id/show", VideoOperationLive, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", CreatorsPortalWeb do
  #   pipe_through :api
  # end
end
