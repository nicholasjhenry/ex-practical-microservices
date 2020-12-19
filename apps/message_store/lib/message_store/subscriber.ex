defmodule MessageStore.Subscriber do
  defstruct position: 0

  def start(nil) do
    %__MODULE__{}
  end

  def start(subscription_message) do
    %__MODULE__{position: subscription_message.position}
  end
end
