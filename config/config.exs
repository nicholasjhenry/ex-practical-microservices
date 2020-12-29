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
config :video_tutorials,
  ecto_repos: [VideoTutorials.Repo]

config :video_tutorials, VideoTutorials.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :video_tutorials_web,
  ecto_repos: [VideoTutorials.Repo],
  generators: [context_app: :video_tutorials]

# Configures the endpoint
config :video_tutorials_web, VideoTutorialsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nWG8mQULVwThV/NqajHmzKVVECvb/UEvSJj0ysLavVZffOt/sN6wafoew294Pfyg",
  render_errors: [view: VideoTutorialsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: VideoTutorials.PubSub,
  live_view: [signing_salt: "ogYiZTbx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
