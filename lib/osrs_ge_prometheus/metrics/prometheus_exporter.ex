defmodule OsrsGePrometheus.Metrics.PrometheusExporter do
  use Prometheus.PlugExporter

  def all_setup() do
    OsrsGePrometheus.Metrics.HiPriceInstrumenter.setup()
    OsrsGePrometheus.Metrics.LoPriceInstrumenter.setup()
    OsrsGePrometheus.Metrics.HiAlchInstrumenter.setup()
  end

  def send_metrics(item) do
    OsrsGePrometheus.Metrics.HiPriceInstrumenter.add(item)
    OsrsGePrometheus.Metrics.LoPriceInstrumenter.add(item)
    OsrsGePrometheus.Metrics.HiAlchInstrumenter.add(item)
  end
end
