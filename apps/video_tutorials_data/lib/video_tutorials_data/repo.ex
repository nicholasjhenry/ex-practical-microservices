defmodule VideoTutorialsData.Repo do
  use Ecto.Repo,
    otp_app: :video_tutorials_data,
    adapter: Ecto.Adapters.Postgres
end
