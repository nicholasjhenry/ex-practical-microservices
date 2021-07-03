defmodule VideoTutorialsData.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :video_tutorials_data,
    adapter: Ecto.Adapters.Postgres
end
