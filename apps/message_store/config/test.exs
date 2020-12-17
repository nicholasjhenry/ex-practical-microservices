use Mix.Config

default_config = [
  username: "postgres",
  password: "postgres",
  database: "message_store_test",
  hostname: "localhost",
  pool_size: 1
]

config :message_store, TestMessageStore, default_config
