defmodule Mix.Tasks.MessageStore.Init do
  use Mix.Task

  @shortdoc "Init the database"

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:message_store)
    MessageStore.Repo.start_link([])
    MessageStore.Repo.init()
  end
end
