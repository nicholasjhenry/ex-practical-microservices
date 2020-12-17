defmodule VideoTutorials.Repo do
  use Ecto.Repo,
    otp_app: :video_tutorials,
    adapter: Ecto.Adapters.Postgres
end
