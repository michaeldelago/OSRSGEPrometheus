import Config

config :osrs_ge_prometheus,
  user_agent: System.get_env("USER_AGENT") || raise """
  You need to set up the USER_AGENT environment variable!
  Suggested Value:
  OSRS_GE_PROMETHEUS @YOUR_DISCORD_HANDLE#1234
  """

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """


  config :osrs_ge_prometheus, OsrsGePrometheusWeb.Endpoint,
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  config :osrs_ge_prometheus, OsrsGePrometheusWeb.Endpoint, server: true
end
