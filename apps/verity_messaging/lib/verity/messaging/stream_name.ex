defmodule Verity.Messaging.StreamName do
  def stream_name(category, id) do
    "#{category}-#{id}"
  end

  def stream_name_to_id(stream_name) do
    [_category | rest] = String.split(stream_name, "-")
    Enum.join(rest, "-")
  end
end
