defmodule VideoTutorialsWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @mix_env Mix.env()

  def start(_type, _args) do
    children =
      [
        # Start the Telemetry supervisor
        VideoTutorialsWeb.Telemetry,
        # Start the Endpoint (http/https)
        VideoTutorialsWeb.Endpoint,
        # Start the PubSub system
        {Phoenix.PubSub, name: VideoTutorials.PubSub}
        # Start a worker by calling: VideoTutorialsWeb.Worker.start_link(arg)
        # {VideoTutorialsWeb.Worker, arg}
      ] ++ consumers(@mix_env)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VideoTutorialsWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VideoTutorialsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp consumers(:test), do: []

  defp consumers(_env) do
    [
      {
        MessageStore.SubscriberWorker,
        [
          config: %{
            stream_name: "aggregators:home-page",
            subscribed_to: "viewing",
            handler: VideoTutorials.HomePage
          }
        ]
      }
    ]
  end
end
