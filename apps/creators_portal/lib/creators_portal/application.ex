defmodule CreatorsPortal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Start the PubSub system
      {Phoenix.PubSub, name: CreatorsPortal.PubSub}
      # Start a worker by calling: CreatorsPortal.Worker.start_link(arg)
      # {CreatorsPortal.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: CreatorsPortal.Supervisor)
  end
end
