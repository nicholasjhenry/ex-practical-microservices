defmodule CreatorsPortal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @mix_env Mix.env()

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Start the PubSub system
      {Phoenix.PubSub, name: CreatorsPortal.PubSub}
      # Start a worker by calling: CreatorsPortal.Worker.start_link(arg)
      # {CreatorsPortal.Worker, arg}
    ] ++ consumers(@mix_env)

    Supervisor.start_link(children, strategy: :one_for_one, name: CreatorsPortal.Supervisor)
  end

   # TODO: add own supervisor for consumers
  defp consumers(:test), do: []
  defp consumers(_env) do
    [
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:creators-videos", subscribed_to: "videoPublishing", handler: VideoTutorials.CreatorsVideos}]
      }
    ]
  end
end
