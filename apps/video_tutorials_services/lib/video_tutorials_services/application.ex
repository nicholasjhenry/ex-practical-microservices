defmodule VideoTutorialsServices.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @mix_env Mix.env()

  def start(_type, _args) do
    children = [
      # Start a worker by calling: VideoTutorialsServices.Worker.start_link(arg)
      # {VideoTutorialsServices.Worker, arg}
    ] ++ consumers(@mix_env)

    Supervisor.start_link(children, strategy: :one_for_one, name: VideoTutorialsServices.Supervisor)
  end

   # TODO: add own supervisor for consumers
  defp consumers(:test), do: []
  defp consumers(_env) do
    [
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:identity:command", subscribed_to: "identity:command", handler: VideoTutorialsServices.Identity}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:identity", subscribed_to: "identity", handler: VideoTutorialsServices.Identity}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:identity:sendEmailEvents", subscribed_to: "sendEmail", handler: VideoTutorialsServices.Identity, opts: [origin_stream_name: "identity"]}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:user-credentials", subscribed_to: "identity", handler: VideoTutorialsServices.UserCredentials}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:admin-users", subscribed_to: "identity", handler: VideoTutorialsServices.AdminUsers}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:send-email:command", subscribed_to: "sendEmail:command", handler: VideoTutorialsServices.SendEmail}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:video-operations", subscribed_to: "videoPublishing", handler: VideoTutorialsServices.VideoOperations}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:creators-videos", subscribed_to: "videoPublishing", handler: VideoTutorialsServices.CreatorsVideos}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "components:name-video", subscribed_to: "videoPublishing:command", handler: VideoPublishing.NameVideo}]
      },
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:admin-streams", subscribed_to: "$all", handler: VideoTutorialsServices.AdminStreams}]
      },
      # TODO subscribe_to: "components:*"
      {
        MessageStore.SubscriberWorker,
        [config: %{stream_name: "aggregators:admin-subscriber-positions", subscribed_to: "$all", handler: VideoTutorialsServices.AdminSubscriberPositions, opts: [filter: "components"]}]
      }
    ]
  end
end
