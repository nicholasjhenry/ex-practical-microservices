defmodule MessageStore.Driver do
  def get do
    Application.get_env(:message_store, :driver, MessageStore.Driver.Postgrex)
  end

  defmodule Postgrex do
    def config() do
      Application.fetch_env!(:message_store, MessageStore.Repo)
    end

    def query(sql, params) do
      Elixir.Postgrex.query(conn(), sql, params)
    end

    def query!(sql, params) do
      Elixir.Postgrex.query!(conn(), sql, params)
    end

    defp conn(), do: Process.whereis(MessageStore.Repo)
  end
end
