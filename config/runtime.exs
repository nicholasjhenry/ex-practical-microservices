import Config

config :master_proxy,
  http: [port: String.to_integer(System.get_env("PORT", "4000"))],
  log_requests: true,
  backends: [
    %{
      path: ~r{^/creators_portal},
      phoenix_endpoint: CreatorsPortalWeb.Endpoint
    },
    %{
      path: ~r{^/admin},
      phoenix_endpoint: VideoTutorialsBackOfficeWeb.Endpoint
    },
    %{
      phoenix_endpoint: VideoTutorialsWeb.Endpoint
    }
  ]

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  database_ssl = if System.get_env("DATABASE_SSL") == "0" do
    false
  else
    true
  end

  config :video_tutorials_data, VideoTutorialsData.Repo,
    ssl: database_ssl,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    after_connect: {Postgrex, :query!, ["SET search_path TO public, message_store", []]}

  config :message_store, driver: VideoTutorialsData.Repo

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """
  host =
    System.get_env("HOST") ||
      raise """
      environment variable HOST is missing.
      For example: example.com
      """

  config :video_tutorials_web, VideoTutorialsWeb.Endpoint,
    url: [scheme: "https", host: host, port: 443],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base

  config :video_tutorials_back_office, VideoTutorialsBackOfficeWeb.Endpoint,
    url: [scheme: "https", host: host, port: 443],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base

  config :creators_portal_web, CreatorsPortalWeb.Endpoint,
    url: [scheme: "https", host: host, port: 443],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4003"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base
end
