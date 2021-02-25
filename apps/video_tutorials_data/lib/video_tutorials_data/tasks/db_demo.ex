defmodule VideoTutorialsData.Tasks.DbDemo do
  import VideoTutorialsData.Tasks

  def exec do
    seed(:video_tutorials_data, [VideoTutorialsData.Repo])
  end

  def seed(app, repos) do
    start_services(app, repos)

    run_seeds(app)

    stop_services()
  end

  def run_seeds(app) do
    IO.puts("Running demo script..")
    seed_script = Path.join([:code.priv_dir(app), "repo/demo.exs"])
    Code.eval_file(seed_script)
  end
end
