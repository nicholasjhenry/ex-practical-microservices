defmodule MessageStore do
  defmodule VersionConflictError do
    @regex ~r/Wrong expected version: \d+ \(Stream: \D+-\d+, Stream Version: ([0-9-])+\)/
    defexception [:message]

    def reraise(error) do
      match = Regex.match?(@regex, error.postgres.message)

      case  match do
        true ->
          raise VersionConflictError, error.postgres.message
        _ -> raise error
      end
    end
  end

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

    execute_function(conn, "SELECT #{function_call}", params)
  end

  def get_stream_messages(stream_name) do
    conn = Process.whereis(MessageStore.Repo)

    function_call = "get_stream_messages($1)"
    %Postgrex.Result{rows: [rows]} = execute_function(conn, "SELECT #{function_call}", [stream_name])

    Enum.map(rows, fn {id, stream_name, type, position, gobal_position, data, metadata, time} ->
      %{
        id: id,
        stream_name: stream_name,
        type: type,
        position: position,
        global_position: gobal_position,
        data: Jason.decode!(data),
        metadata: Jason.decode!(metadata),
        time: time
      }
    end)
  end

  def get_category_messages(stream_name, position) do
    conn = Process.whereis(MessageStore.Repo)

    function_call = "get_category_messages($1, $2)"
    %Postgrex.Result{rows: rows} = execute_function(conn, "SELECT #{function_call}", [stream_name, position])

    case rows do
      [rows] ->
        Enum.map(rows, fn {id, stream_name, type, position, gobal_position, data, metadata, time} ->
          %{
            id: id,
            stream_name: stream_name,
            type: type,
            position: position,
            global_position: gobal_position,
            data: Jason.decode!(data),
            metadata: Jason.decode!(metadata),
            time: time
          }
      end)
      [] -> []
    end
  end

  def read_last_message(stream_name) do
    conn = Process.whereis(MessageStore.Repo)

    function_call = "get_last_stream_message($1)"
    case execute_function(conn, "SELECT * FROM #{function_call}", [stream_name]) do
      %Postgrex.Result{rows: [rows]} ->
        [id, stream_name, type, position, gobal_position, data, metadata, time]= rows

        %{
          id: id,
          stream_name: stream_name,
          type: type,
          position: position,
          global_position: gobal_position,
          data: Jason.decode!(data),
          metadata: Jason.decode!(metadata),
          time: time
        }
      %Postgrex.Result{rows: []} ->
        nil
    end
  end

  defp execute_function(conn, sql, params) do
    try do
      query = Postgrex.prepare!(conn, "", sql)
      Postgrex.execute!(conn, query, params)
    rescue
      error in [Postgrex.Error] ->
        VersionConflictError.reraise(error)
    end
  end
end
