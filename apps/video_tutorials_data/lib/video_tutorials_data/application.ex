defmodule VideoTutorialsData.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @mix_env Mix.env()

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: VideoTutorialsData.Worker.start_link(arg)
      # {VideoTutorialsData.Worker, arg}
      # Start the Ecto repository
      VideoTutorialsData.Repo
    ] ++ children(@mix_env)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VideoTutorialsData.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Use a independent Postgres connection so we don't pollute the logs
  defp children(:dev) do
    [MessageStore.Repo]
  end
  defp children(_env), do: []
end
