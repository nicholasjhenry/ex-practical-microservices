defmodule MessageStore.Repo do

  @schema_name "message_store"

  def start_link([]) do
    Postgrex.start_link(config() ++ [name: __MODULE__, after_connect: after_connect_callback()])
  end

  def start_link(opts) do
    Postgrex.start_link(opts)
  end

  def after_connect_callback do
    {Postgrex, :query!, ["SET search_path TO public, #{@schema_name}", []]}
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
    MessageStore.Driver.get().config()
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

    Postgrex.query!(conn, query, [])
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

    Postgrex.query!(conn, query, [])
  end

  def truncate_messages do
    query = """
    truncate table #{@schema_name}.messages;
    """

    query!(query, [])

    query = """
    ALTER SEQUENCE #{@schema_name}.messages_global_position_seq RESTART WITH 1;
    """

    query!(query, [])
  end

  def query(sql, params) do
    MessageStore.Driver.get().query(sql, params)
  end

  def query!(sql, params) do
    MessageStore.Driver.get().query!(sql, params)
  end
end
