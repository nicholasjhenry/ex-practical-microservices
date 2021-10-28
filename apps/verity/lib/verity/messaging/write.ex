defmodule Verity.Messaging.Write do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/writing/message-writer.html
  """
  alias MessageStore.MessageData

  def write(%MessageData.Write{} = message_data, stream_name) do
    message_data = %{message_data | stream_name: stream_name}
    MessageStore.write_message(message_data)
  end

  def write(message, stream_name) do
    message |> message.__struct__.to_message_data |> write(stream_name)
  end
end
