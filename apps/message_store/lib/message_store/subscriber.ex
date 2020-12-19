defmodule MessageStore.Subscriber do
  defstruct next_position: 0, handled_message_result: nil

  def start(nil) do
    %__MODULE__{}
  end

  def start(subscription_message) do
    %__MODULE__{next_position: subscription_message.position + 1}
  end

  def handle_message(subscriber, message, handler) do
    result = handler.(message)
    %{subscriber | next_position: subscriber.next_position + 1, handled_message_result: result}
  end
end
