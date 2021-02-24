defmodule VideoTutorials.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @mix_env Mix.env()

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      VideoTutorials.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: VideoTutorials.PubSub}
      # Start a worker by calling: VideoTutorials.Worker.start_link(arg)
      # {VideoTutorials.Worker, arg}
    ] ++ children(@mix_env) ++ consumers(@mix_env)

    Supervisor.start_link(children, strategy: :one_for_one, name: VideoTutorials.Supervisor)
  end

  # Use a independent Postgres connection so we don't pollute the logs
  defp children(:dev) do
    [MessageStore.Repo]
  end
  defp children(_env), do: []

   # TODO: add own supervisor for consumers
  defp consumers(:test), do: []
  defp consumers(_env) do
    [
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:home-page", subscribed_to: "viewing", handler: VideoTutorials.HomePage}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:identity:command", subscribed_to: "identity:command", handler: VideoTutorials.Identity}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:identity", subscribed_to: "identity", handler: VideoTutorials.Identity}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:identity:sendEmailEvents", subscribed_to: "sendEmail", handler: VideoTutorials.Identity, opts: [origin_stream_name: "identity"]}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:user-credentials", subscribed_to: "identity", handler: VideoTutorials.UserCredentials}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:send-email:command", subscribed_to: "sendEmail:command", handler: VideoTutorials.SendEmail}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:video-operations", subscribed_to: "videoPublishing", handler: VideoTutorials.VideoOperations}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:creators-videos", subscribed_to: "videoPublishing", handler: VideoTutorials.CreatorsVideos}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:name-video", subscribed_to: "videoPublishing:command", handler: VideoPublishing.NameVideo}]
      }
    ]
  end
end
