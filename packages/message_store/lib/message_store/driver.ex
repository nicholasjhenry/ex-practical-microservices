defmodule MessageStore.Driver do
  def get do
    Application.get_env(:message_store, :driver, MessageStore.Driver.Postgrex)
  end

  defmodule Postgrex do
    def query(sql, params) do
      query = Elixir.Postgrex.prepare!(conn(), "", sql)
      Elixir.Postgrex.execute!(conn(), query, params)
    end

    def query!(query, params) do
      Elixir.Postgrex.query!(conn(), query, params)
    end

    defp conn(), do: Process.whereis(MessageStore.Repo)
  end
end
