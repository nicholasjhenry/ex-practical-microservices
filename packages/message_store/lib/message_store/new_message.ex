defmodule MessageStore.NewMessage do
  @enforce_keys [:id, :stream_name, :type, :data, :metadata, :expected_version]
  defstruct [:id, :stream_name, :type, :data, :metadata, :expected_version]

  def new(attrs) do
    defaults = [id: UUID.uuid4(), metadata: %{}, expected_version: -1]
    attrs = Keyword.merge(defaults, attrs)
    struct!(__MODULE__, attrs)
  end
end
