defmodule Verity.Messaging.StreamName do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/stream-names/messaging-stream-name.html
  """

  def stream_name(category, id) do
    "#{category}-#{id}"
  end

  def stream_name_to_id(stream_name) do
    [_category | rest] = String.split(stream_name, "-")
    Enum.join(rest, "-")
  end
end
