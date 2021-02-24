defmodule VideoTutorials.Tasks.MessageStoreInit do
  import VideoTutorials.Tasks

  def exec do
    init(:video_tutorials, [VideoTutorialsData.Repo])
  end

  def init(app, repos) do
    start_services(app, repos)

    MessageStore.Repo.init()

    stop_services()
  end
end
