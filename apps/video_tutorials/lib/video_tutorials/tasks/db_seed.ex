defmodule VideoTutorials.Tasks.DbSeed do
  import VideoTutorials.Tasks

  def exec do
    seed(:video_tutorials, [VideoTutorials.Repo])
  end

  def seed(app, repos) do
    start_services(app, repos)

    run_seeds(app)

    stop_services()
  end

  def run_seeds(app) do
    # Run the seed script if it exists
    seed_script = Path.join([:code.priv_dir(app), "seeds.exs"])

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end
end
