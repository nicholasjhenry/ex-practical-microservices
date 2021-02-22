defmodule VideoTutorials.Tasks do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

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

  def priv_path_for(repo, filename) do
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
