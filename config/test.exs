use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :video_tutorials_data, VideoTutorialsData.Repo,
  username: "postgres",
  password: "postgres",
  database: "video_tutorials_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  after_connect: {Postgrex, :query!, ["SET search_path TO public, message_store", []]}

config :message_store, driver: VideoTutorialsData.Repo

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :video_tutorials_web, VideoTutorialsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :video_tutorials_back_office, VideoTutorialsBackOfficeWeb.Endpoint,
  http: [port: 4006],
  server: false

config :creators_portal_web, CreatorsPortalWeb.Endpoint,
  http: [port: 4004],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :video_tutorials_services, VideoTutorialsServices.Mailer, adapter: Bamboo.TestAdapter
