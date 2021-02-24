defmodule VideoTutorialsData.Tasks.MessageStoreInit do
  import VideoTutorialsData.Tasks

  def exec do
    init(:video_tutorials_data, [VideoTutorialsData.Repo])
  end

  def init(app, repos) do
    start_services(app, repos)

    MessageStore.Repo.init()

    stop_services()
  end
end
