defmodule MessageStore do
  @moduledoc """
  Documentation for `MessageStore`.
  """
  def write_message(message) do
    conn = Process.whereis(MessageStore.Repo)

    function_call = "write_message($1, $2, $3, $4, $5, $6)"

    params = [
      message.id,
      message.stream_name,
      message.type,
      message.data,
      message.metadata,
      message.expected_version
    ]

    query = Postgrex.prepare!(conn, "", "SELECT #{function_call}")
    Postgrex.execute!(conn, query, params)
  end

  def get_stream_messages(stream_name) do
    conn = Process.whereis(MessageStore.Repo)

    function_call = "get_stream_messages($1)"

    params = [stream_name]

    query = Postgrex.prepare!(conn, "", "SELECT #{function_call}")
    %Postgrex.Result{rows: [rows]} = Postgrex.execute!(conn, query, params)

    Enum.map(rows, fn {id, stream_name, type, position, gobal_position, data, metadata, time} ->
      %{
        id: id,
        stream_name: stream_name,
        type: type,
        data: Jason.decode!(data),
        metadata: Jason.decode!(metadata),
        time: time
      }
    end)
  end
end
