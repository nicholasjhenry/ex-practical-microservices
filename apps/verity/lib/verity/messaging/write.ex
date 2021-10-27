defmodule Verity.Messaging.Write do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/writing/message-writer.html
  """

  def write(message, stream_name) do
    message = %{message | stream_name: stream_name}
    MessageStore.write_message(message)
  end
end
