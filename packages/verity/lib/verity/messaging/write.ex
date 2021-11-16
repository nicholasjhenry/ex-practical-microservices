defmodule Verity.Messaging.Write do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/writing/message-writer.html
  """
  alias MessageStore.MessageData

  def write(message_data_write_or_struct, stream_name, opts \\ [])

  def write(%MessageData.Write{} = message_data, stream_name, opts) do
    expected_version = Keyword.get(opts, :expected_version)
    message_data = %{message_data | stream_name: stream_name, expected_version: expected_version}
    MessageStore.write_message(message_data)
  end

  def write(message, stream_name, opts) do
    message |> message.__struct__.to_message_data |> write(stream_name, opts)
  end
end
