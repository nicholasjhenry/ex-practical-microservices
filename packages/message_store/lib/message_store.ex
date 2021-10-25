defmodule MessageStore do
  @moduledoc """
  Documentation for `MessageStore`.
  """

  alias MessageStore.{MessageData, Repo}

  defmodule VersionConflictError do
    @regex ~r/Wrong expected version: \d+ \(Stream: \D+-\d+, Stream Version: ([0-9-])+\)/
    defexception [:message]

    def reraise(error) do
      match = Regex.match?(@regex, error.postgres.message)

      case match do
        true ->
          raise VersionConflictError, error.postgres.message

        _ ->
          raise error
      end
    end
  end

  def write_message(message) do
    function_call = "write_message($1, $2, $3, $4, $5, $6)"

    params = [
      message.id,
      message.stream_name,
      message.type,
      message.data,
      message.metadata,
      message.expected_version
    ]

    execute_function(function_call, params)

    :ok
  end

  def get_stream_messages(stream_name) do
    function_call = "get_stream_messages($1)"

    function_call
    |> execute_function([stream_name])
    |> handle_result_rows
  end

  def get_category_messages("$all", position) do
    function_call = """
      id::varchar,
      stream_name::varchar,
      type::varchar,
      position::bigint,
      global_position::bigint,
      data::varchar,
      metadata::varchar,
      time::timestamp
    FROM
      messages
    WHERE
      global_position > $1
    LIMIT 1000
    """

    function_call
    |> execute_function([position])
    |> handle_result_rows
  end

  def get_category_messages(stream_name, position) do
    function_call = "get_category_messages($1, $2)"

    function_call
    |> execute_function([stream_name, position])
    |> handle_result_rows
  end

  def read_last_message(stream_name) do
    function_call = "get_last_stream_message($1)"

    function_call
    |> execute_function([stream_name])
    |> handle_result_rows
    |> List.first()
  end

  def fetch(stream_name, projection) do
    stream_name
    |> get_stream_messages()
    |> project(projection)
  end

  defp handle_result_rows(%Postgrex.Result{rows: []}), do: []

  defp handle_result_rows(%Postgrex.Result{rows: rows}) do
    Enum.map(rows, &to_message(&1))
  end

  defp to_message([{id, stream_name, type, position, gobal_position, data, metadata, time}]) do
    MessageData.Read.new(
      id: id,
      stream_name: stream_name,
      type: type,
      position: position,
      global_position: gobal_position,
      data: Jason.decode!(data),
      metadata: Jason.decode!(metadata),
      time: time
    )
  end

  defp to_message(row), do: row |> List.to_tuple() |> List.wrap() |> to_message()

  defp execute_function(sql, params) do
    try do
      Repo.query!("SELECT #{sql}", params)
    rescue
      error in [Postgrex.Error] ->
        VersionConflictError.reraise(error)
    end
  end

  defp project(events, projection) do
    Enum.reduce(events, projection.init(), &projection.apply(&2, &1))
  end
end
