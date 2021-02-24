defmodule VideoTutorials.Tasks.DbMigrate do
  @moduledoc """
  Functions called when releasing a new version of the application.
  """

  import VideoTutorials.Tasks

  def exec do
    migrate(:video_tutorials, [VideoTutorialsData.Repo])
  end

  def migrate(app, repos) do
    start_services(app, repos)

    run_migrations(repos)

    stop_services()
  end

  defp run_migrations(repos) do
    Enum.each(repos, &run_migrations_for/1)
  end

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    migrations_path = priv_path_for(repo, "migrations")
    Ecto.Migrator.run(repo, migrations_path, :up, all: true)
  end
end
