# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :video_tutorials_data,
  ecto_repos: [VideoTutorialsData.Repo]

config :video_tutorials_data, VideoTutorialsData.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :video_tutorials_services,
  ecto_repos: [VideoTutorialsData.Repo]

config :video_tutorials_web,
  ecto_repos: [VideoTutorialsData.Repo]

config :video_tutorials_web, VideoTutorialsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nWG8mQULVwThV/NqajHmzKVVECvb/UEvSJj0ysLavVZffOt/sN6wafoew294Pfyg",
  render_errors: [view: VideoTutorialsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: VideoTutorials.PubSub,
  live_view: [signing_salt: "ogYiZTbx"]

config :video_tutorials_back_office,
  ecto_repos: [VideoTutorialsData.Repo]

config :video_tutorials_back_office, VideoTutorialsBackOfficeWeb.Endpoint,
  url: [host: "localhost"],
  static_url: [path: "/admin"],
  secret_key_base: "nWG8mQULVwThV/NqajHmzKVVECvb/UEvSJj0ysLavVZffOt/sN6wafoew294Pfyg",
  render_errors: [
    view: VideoTutorialsBackOfficeWeb.ErrorView,
    accepts: ~w(html json),
    layout: false
  ],
  pubsub_server: VideoTutorialsBackOffice.PubSub,
  live_view: [signing_salt: "aaEvNyio"]

config :creators_portal_web,
  ecto_repos: [VideoTutorialsData.Repo],
  generators: [context_app: :creators_portal]

config :creators_portal_web, CreatorsPortalWeb.Endpoint,
  url: [host: "localhost"],
  static_url: [path: "/creators_portal"],
  secret_key_base: "H8QmQV7cskO0xeFoM+zHkg9YKksmYn8DudcIt7Qn8ZfNS+K23KeigQwk3M1cxtQI",
  render_errors: [view: CreatorsPortalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CreatorsPortal.PubSub,
  live_view: [signing_salt: "9gshzUVU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
