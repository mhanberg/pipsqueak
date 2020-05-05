use Mix.Config

# Configure your database
config :pipsqueak, Pipsqueak.Repo,
  username: "postgres",
  password: "postgres",
  database: "pipsqueak_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pipsqueak, PipsqueakWeb.Endpoint,
  http: [port: 4002],
  server: true

config :pipsqueak, :sql_sandbox, true

config :wallaby,
  driver: Wallaby.Experimental.Chrome,
  chromedriver: [
    headless: false,
    path: "/usr/local/bin/geckodriver"
  ],
  otp_app: :pipsqueak

# Print only warnings and errors during test
config :logger, level: :warn
