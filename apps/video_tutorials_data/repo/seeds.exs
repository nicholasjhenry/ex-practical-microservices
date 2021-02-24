# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VideoTutorialsData.Repo.insert!(%VideoTutorials.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


VideoTutorialsData.Repo.insert!(
  %VideoTutorials.Page{name: "home", data: %{"videos_watched" => 0, "last_view_processed" => 0}},
  on_conflict: :nothing
)
