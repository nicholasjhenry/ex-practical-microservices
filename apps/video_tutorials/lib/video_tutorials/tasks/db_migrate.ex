defmodule VideoTutorials.Tasks.DbMigrate do
  @moduledoc """
  Functions called when releasing a new version of the application.
  """

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  def exec do
    migrate(:video_tutorials, [VideoTutorials.Repo])
  end

  def migrate(app, repos) do
    start_services(app, repos)

    run_migrations(repos)

    stop_services()
  end

  def start_services(app, repos) do
    IO.puts("Loading #{app}..")

    # Load the code for myapp, but don't start it
    _ = Application.load(app)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    _ = Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for app
    IO.puts("Starting repos (#{inspect(repos)})..")
    Enum.each(repos, & &1.start_link(pool_size: 2))
  end

  def stop_services do
    IO.puts("Success!")
    :init.stop()
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

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
