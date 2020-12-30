defmodule MessageStore.SubscriberWorker do
  use GenServer

  alias MessageStore.SubscriberService

  # Public API

  def start_link(args) do
    {%{} = config, opts} = Keyword.pop(args, :config)
    GenServer.start_link(__MODULE__, config, [{:name, String.to_atom(config.stream_name)} | opts])
  end

  def child_spec(opts) do
    %{
      id: String.to_atom(opts[:config].stream_name),
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  # Callbacks

  @impl true
  def init(config) do
    {:ok, subscriber} = SubscriberService.start(config.stream_name, config.subscribed_to)

    Process.send_after(self(), :tick, 10)

    {:ok, %{subscriber: subscriber, handler: config.handler}}
  end

  @impl true
  def handle_info(:tick, state) do
    subscriber = SubscriberService.run(state.subscriber, state.handler)
    Process.send_after(self(), :tick, 10)

    {:noreply, %{state | subscriber: subscriber}}
  end
end
