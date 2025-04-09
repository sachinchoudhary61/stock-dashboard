import Config

if config_env() == :prod do
  config :stock_dashboard, StockDashboard.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  config :stock_dashboard, StockDashboardWeb.Endpoint,
    server: true,
    url: [host: System.fetch_env!("PHX_HOST"), port: 443],
    http: [port: String.to_integer(System.get_env("PORT") || "4000")]

  config :logger, level: :info
end
