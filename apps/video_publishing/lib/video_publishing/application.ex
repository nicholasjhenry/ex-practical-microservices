defmodule VideoPublishing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @mix_env Mix.env()

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VideoPublishing.Supervisor]
    Supervisor.start_link(consumers(@mix_env), opts)
  end

  defp consumers(:test), do: []
  defp consumers(_env) do
    [
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:name-video", subscribed_to: "videoPublishing:command", handler: VideoPublishing.NameVideo}]
      }
    ]
  end
end
