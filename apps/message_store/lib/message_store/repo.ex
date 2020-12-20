defmodule MessageStore.Repo do

  @schema_name "message_store"

  def start_link([]) do
    after_connect_callback = {Postgrex, :query!, ["SET search_path TO public, #{@schema_name}", []]}
    Postgrex.start_link(config() ++ [name: __MODULE__, after_connect: after_connect_callback])
  end

  def start_link(opts) do
    Postgrex.start_link(opts)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def config do
    Application.fetch_env!(:message_store, __MODULE__)
  end

  def create do
    config = config()
    database_name = Keyword.fetch!(config, :database)

    config = config
    |> Keyword.drop([:database])
    |> Keyword.put(:database, "postgres")

    {:ok, conn} = Postgrex.start_link(config)

    query = """
    create database #{database_name}
    """

    query = Postgrex.prepare!(conn, "", query)
    Postgrex.execute!(conn, query, [])
  end

  def drop do
    config = config()
    database_name = Keyword.fetch!(config, :database)

    config = config
    |> Keyword.drop([:database])
    |> Keyword.put(:database, "postgres")

    {:ok, conn} = Postgrex.start_link(config)

    query = """
    drop database if exists #{database_name}
    """

    query = Postgrex.prepare!(conn, "", query)
    Postgrex.execute!(conn, query, [])
  end

  def truncate_messages do
    {:ok, conn} = Postgrex.start_link(config())

    query = """
    truncate table #{@schema_name}.messages;
    """

    Postgrex.query!(conn, query, [])

    query = """
    ALTER SEQUENCE #{@schema_name}.messages_global_position_seq RESTART WITH 1;
    """

    Postgrex.query!(conn, query, [])
  end
end
