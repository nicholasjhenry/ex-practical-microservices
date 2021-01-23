# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CreatorsPortal.Repo.insert!(%CreatorsPortal.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

VideoTutorials.Repo.insert!(
  %CreatorsPortal.Video{
    owner_id: "1F2D2A6F-47DB-477F-9C48-7A706AF3A038",
    name: "Untitled",
    description: "Example",
    source_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA",
    transcoded_uri: "https://www.youtube.com/watch?v=GI_P3UtZXAA"
  }
)
