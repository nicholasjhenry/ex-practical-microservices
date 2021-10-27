defmodule Verity.Messaging.StreamName do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/stream-names/messaging-stream-name.html
  """

  def command_stream_name(id, category) when is_atom(category) do
    "#{category}:command-#{id}"
  end

  def stream_name(id, category) when is_atom(category) do
    "#{category}-#{id}"
  end

  def stream_name_to_id(stream_name) do
    [_category | rest] = String.split(stream_name, "-")
    Enum.join(rest, "-")
  end
end
