defmodule VideoTutorials.HomePage do
  alias VideoTutorials.Page

  # Handlers
  def handle_message(event) do
    increment_videos_watched(event.global_position)
  end

  # Callbacks

  def increment_videos_watched(global_position) do
    import Ecto.Query, only: [from: 2]

    # TODO: Optimize, handle race conditions
    query = from page in Page,
      where: fragment("(data->>'last_viewed_processed')::int < ?", ^global_position)

    page = VideoTutorials.Repo.get_by(query, name: "home")

    if page do
      data = %{"videos_watched" => page.data["videos_watched"] + 1, "last_view_processed" => global_position}
      change = Ecto.Changeset.change(page, data: data)
      VideoTutorials.Repo.update(change)
    end
  end
end
