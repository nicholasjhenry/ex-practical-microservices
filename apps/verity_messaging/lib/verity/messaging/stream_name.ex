defmodule Verity.Messaging.StreamName do
  def stream_name(category, id) do
    "#{category}-#{id}"
  end
end
