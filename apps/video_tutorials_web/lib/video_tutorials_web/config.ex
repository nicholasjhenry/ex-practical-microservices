defmodule VideoTutorialsWeb.Config do
  @moduledoc false

  # Idiomatically, this would be configured in the `config/`. Let's see how this plays out
  # based on the example on page 8.

  defstruct [:app_name, :env, :port, :version]

  @application_name :video_tutorials_web

  def get do
    %__MODULE__{
      app_name: "Video Tutorials",
      env: Mix.env(),
      port: port(),
      version: version()
    }
  end

  defp port do
    end_point_env = Application.fetch_env!(@application_name, VideoTutorialsWeb.Endpoint)

    end_point_env
    |> Keyword.fetch!(:http)
    |> Keyword.fetch!(:port)
  end

  defp version do
    Application.spec(@application_name, :vsn) |> to_string
  end
end
