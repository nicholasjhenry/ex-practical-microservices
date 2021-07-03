defmodule CreatorsPortalWeb do
  @moduledoc """
  The entrypoint for the creators portal.
  """

  @doc false
  def controller do
    quote do
      @moduledoc false

      use Phoenix.Controller, namespace: CreatorsPortalWeb

      import Plug.Conn
      import CreatorsPortalWeb.Gettext
      alias CreatorsPortalWeb.Router.Helpers, as: Routes
    end
  end

  @doc false
  def view do
    quote do
      @moduledoc false

      use Phoenix.View,
        root: "lib/creators_portal_web/templates",
        namespace: CreatorsPortalWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  @doc false
  def live_view do
    quote do
      @moduledoc false

      use Phoenix.LiveView,
        layout: {CreatorsPortalWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  @doc false
  def live_component do
    quote do
      @moduledoc false

      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  @doc false
  def router do
    quote do
      @moduledoc false

      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  @doc false
  def channel do
    quote do
      @moduledoc false

      use Phoenix.Channel
      import CreatorsPortalWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import CreatorsPortalWeb.ErrorHelpers
      import CreatorsPortalWeb.Gettext
      alias CreatorsPortalWeb.Router.Helpers, as: Routes
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
