defmodule Mix.Tasks.MessageStore.Init do
  use Mix.Task

  @shortdoc "Init the database"

  def run(_args) do
    MessageStore.Repo.init()
  end
end
