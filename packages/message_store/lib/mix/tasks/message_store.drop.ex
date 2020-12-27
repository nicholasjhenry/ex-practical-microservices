defmodule Mix.Tasks.MessageStore.Drop do
  use Mix.Task

  @shortdoc "Drops the database for the MessageStore"

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:postgrex)
    {:ok, _} = Application.ensure_all_started(:ssl)

    MessageStore.Repo.drop()
    Mix.shell().info("Message store dropped.")
  end
end
