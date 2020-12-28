defmodule VideoTutorials.HomePage do
  alias VideoTutorials.Page

  # Handlers

  def handle_message(event) do
    increment_videos_watched(event.global_position)
  end

  # Callbacks

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
    VideoTutorials.Repo.update_all(query, [])
  end
end
