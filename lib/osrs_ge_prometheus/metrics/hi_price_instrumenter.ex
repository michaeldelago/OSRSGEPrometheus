defmodule OsrsGePrometheus.Metrics.HiPriceInstrumenter do
  use Prometheus.Metric

  def setup() do
    Gauge.declare(
      name: :item_price_hi,
      help: "GE High prices of an item",
      labels: [:item_id, :item_name]
    )
  end

  def add(%OsrsGePrometheus.Item{:name => item_name, :id => item_id, :ge_hi => nil}) do
    Gauge.set(
      [name: :item_price_hi, labels: [item_id, item_name]],
      -1
    )
  end

  def add(%OsrsGePrometheus.Item{:name => item_name, :id => item_id, :ge_hi => ge_hi}) do
    Gauge.set(
      [name: :item_price_hi, labels: [item_id, item_name]],
      ge_hi
    )
  end
end
