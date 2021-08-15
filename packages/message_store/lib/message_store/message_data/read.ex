defmodule MessageStore.MessageData.Read do
  @enforce_keys [:id, :stream_name, :type, :data, :metadata, :position, :global_position, :time]
  defstruct [:id, :stream_name, :type, :data, :metadata, :position, :global_position, :time]

  def new(attrs) do
    struct!(__MODULE__, attrs)
  end
end
