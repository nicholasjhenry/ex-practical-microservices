defmodule MessageStore.Message do
  @enforce_keys [:id, :stream_name, :type, :data, :metadata, :position, :global_position]
  defstruct [:id, :stream_name, :type, :data, :metadata, :position, :global_position]

  def new(attrs) do
    struct!(__MODULE__, attrs)
  end
end
