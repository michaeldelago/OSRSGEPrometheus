defmodule OsrsGePrometheus.Metrics.LoPriceInstrumenter do
  use Prometheus.Metric

  def setup() do
    Gauge.declare(
      name: :item_price_lo,
      help: "GE Low prices of an item",
      labels: [:item_id, :item_name]
    )
  end

  def add(%OsrsGePrometheus.Item{:name => item_name, :id => item_id, :ge_lo => nil}) do
    Gauge.set(
      [name: :item_price_lo, labels: [item_id, item_name]],
      -1
    )
  end

  def add(%OsrsGePrometheus.Item{:name => item_name, :id => item_id, :ge_lo => ge_lo}) do
    Gauge.set(
      [name: :item_price_lo, labels: [item_id, item_name]],
      ge_lo
    )
  end
end
