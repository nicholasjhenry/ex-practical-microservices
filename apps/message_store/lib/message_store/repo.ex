defmodule MessageStore.Repo do
  def config do
    Application.fetch_env!(:message_store, TestMessageStore)
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
    drop database #{database_name}
    """

    query = Postgrex.prepare!(conn, "", query)
    Postgrex.execute!(conn, query, [])
  end
end
