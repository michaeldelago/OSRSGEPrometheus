defmodule OsrsGePrometheus.Metrics.HiAlchInstrumenter do
  use Prometheus.Metric
  import OsrsGePrometheus.Item
  import OsrsGePrometheus

  @nature_rune_id 561

  def setup() do
    Gauge.declare(
      name: :item_hi_alch_profit,
      help: "GE High alch profit of an item",
      labels: [:item_id, :item_name]
    )
  end

  def add(%OsrsGePrometheus.Item{:name => item_name, :id => item_id} = item) do
    nature_rune_price =
      with {:ok, item} <- OsrsGePrometheus.ItemSupervisor.get_child(@nature_rune_id),
           %{:ge_lo => price} <- OsrsGePrometheus.ItemServer.view_info(item) do
        price
      end

    hi_alch_profit = high_alch_profit(item, nature_rune_price)

    Gauge.set(
      [name: :item_hi_alch_profit, labels: [item_id, item_name]],
      hi_alch_profit
    )
  end
end
