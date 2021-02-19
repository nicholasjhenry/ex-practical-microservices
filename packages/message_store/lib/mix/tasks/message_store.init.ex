defmodule Mix.Tasks.MessageStore.Init do
  use Mix.Task

  @shortdoc "Init the database"

  @dirname "message-db"
  @path Path.join([Application.app_dir(:message_store), "priv", @dirname])

  def run(_args) do
    config = MessageStore.Repo.config()
    %{database: database, password: password, username: username, hostname: hostname} = Map.new(config)

    ssl = if config[:ssl] == true do
        "require"
      else
        "allow"
      end

    env = [
      {"DATABASE_NAME", database},
      {"PGPASSWORD", password},
      {"PGUSER", username},
      {"PGHOST", hostname},
      {"PGSSLMODE", ssl},
      {"CREATE_DATABASE", "off"},
    ]

    opts = [
      cd: @path,
      env: env,
      stderr_to_stdout: true,
      into: IO.stream(:stdio, :line)
    ]
    System.cmd("bash", ["database/install.sh"], opts)
  end
end
