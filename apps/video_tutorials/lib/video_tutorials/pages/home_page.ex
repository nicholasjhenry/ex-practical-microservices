defmodule VideoTutorials.HomePage do
  alias VideoTutorials.Page
  alias VideoTutorialsData.Repo

  @topic "viewings"

  # Handlers

  def handle_message(event) do
    increment_videos_watched(event.global_position)
  end

  # API

  def increment_videos_watched(global_position) do
    import Ecto.Query, only: [from: 2]

    query = from page in Page,
      where: page.name == "home" and
             fragment("(data ->> 'last_view_processed')::int < ?", ^global_position),
      update: [set: [data: fragment(
      """
      jsonb_set(
        jsonb_set(
          data,
          '{videos_watched}',
          ((data ->> 'videos_watched')::int + 1)::text::jsonb
        ),
        '{last_view_processed}', ?::text::jsonb
      )
    """, ^to_string(global_position)
    )]]

    query
    |> Repo.update_all([])
    |> broadcast(:home_page_updated)

    :ok
  end

  def load_home_page() do
    Repo.get_by!(Page, name: "home")
  end

  def subscribe do
    Phoenix.PubSub.subscribe(VideoTutorials.PubSub, @topic)
  end

  defp broadcast({0, _}, _event), do: :ok
  defp broadcast({1, _}, event) do
    Phoenix.PubSub.broadcast(VideoTutorials.PubSub, @topic, event)
  end
end
