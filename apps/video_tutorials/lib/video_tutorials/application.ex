defmodule VideoTutorials.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      VideoTutorials.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: VideoTutorials.PubSub}
      # Start a worker by calling: VideoTutorials.Worker.start_link(arg)
      # {VideoTutorials.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: VideoTutorials.Supervisor)
  end
end
