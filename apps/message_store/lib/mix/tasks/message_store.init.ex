defmodule Mix.Tasks.MessageStore.Init do
  use Mix.Task

  @shortdoc "Init the database"

  @repo "git@github.com:message-db/message-db.git"
  @dirname "message-db"

  def run(_args) do
    unless File.exists?(@dirname) do
      System.cmd("git", ["clone", @repo])
    end

    %{database: database, password: password, username: username, hostname: hostname} =
      MessageStore.Repo.config() |> Map.new

    env = [
      {"DATABASE_NAME", database},
      {"PGPASSWORD", password},
      {"PGUSER", username},
      {"PGHOST", hostname}
    ]

    opts = [cd: @dirname, env: env, stderr_to_stdout: true, into: IO.stream(:stdio, :line)]
    System.cmd("bash", ["database/install.sh"], opts)
  end
end
