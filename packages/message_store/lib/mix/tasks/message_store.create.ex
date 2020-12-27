defmodule Mix.Tasks.MessageStore.Create do
  use Mix.Task

  @shortdoc "Create the database for the MessageStore"

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:postgrex)
    {:ok, _} = Application.ensure_all_started(:ssl)

    MessageStore.Repo.create()
    Mix.shell().info("Message store created.")
  end
end
