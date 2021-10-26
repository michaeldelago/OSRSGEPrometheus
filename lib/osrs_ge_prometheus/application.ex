defmodule OsrsGePrometheus.Application do
  use Application

  def start(_type, _args) do
    children = [
      OsrsGePrometheusWeb.Telemetry,
      {Phoenix.PubSub, name: OsrsGePrometheus.PubSub},
      OsrsGePrometheusWeb.Endpoint,
      OsrsGePrometheus.Supervisor
    ]

    OsrsGePrometheus.Metrics.PrometheusExporter.setup()
    OsrsGePrometheus.Metrics.PrometheusExporter.all_setup()

    opts = [strategy: :one_for_one, name: OsrsGePrometheus.Application]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    OsrsGePrometheusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
