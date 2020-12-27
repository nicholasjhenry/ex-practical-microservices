defmodule MessageStore.NewMessage do
  defstruct [:id, :stream_name, :type, :data, :metadata, :expected_version]
end
