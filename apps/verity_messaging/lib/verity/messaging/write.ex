defmodule Verity.Messaging.Write do
  def write(message, stream_name) do
    message = %{message | stream_name: stream_name}
    MessageStore.write_message(message)
  end
end
