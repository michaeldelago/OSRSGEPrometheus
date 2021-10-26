defmodule OsrsGePrometheus.ItemServer do
  use GenServer
  require Logger
  alias OsrsGePrometheus.Item

  @moduledoc """
  GenServer managing state for a single item
  """

  def start_link(init_args \\ %{}) do
    GenServer.start_link(__MODULE__, init_args)
  end

  @spec init(map) :: {:ok, %OsrsGePrometheus.Item{}}
  def init(init_args \\ %{}) do
    state = Item.new(init_args)
    {:ok, state}
  end

  @doc """
  High level API call to set the prices to the item
  """

  @spec set_prices(pid, %{String.t() => integer()}) :: :ok
  def set_prices(pid, prices) do
    GenServer.cast(pid, {:set_prices, prices})
  end

  @doc """
  High level API to return an item. Generally used within iex to confirm the item was correctly set up
  """

  @spec view_info(pid) :: %Item{}
  def view_info(pid) do
    GenServer.call(pid, :view)
  end

  @doc """
  GenServer callback for setting prices.

  Creates an item with the new prices, confirms theres a change, and sets the change as necessary
  """
  def handle_cast({:set_prices, prices}, state) do
    %{"high" => high, "low" => low} = prices
    %Item{
      :ge_hi => old_high,
      :ge_lo => old_low
    } = state

    new_state = state |> Item.set_ge(high, low)

    timestamp_updated =
      cond do
        old_high != high && old_low != low ->
          new_state

        true ->
          new_state |> Item.update_time()
      end

    # Spawn the "send metrics" function in a separate process to keep this one going at its' own pace
    spawn(fn -> OsrsGePrometheus.Metrics.PrometheusExporter.send_metrics(timestamp_updated) end)
    {:noreply, timestamp_updated}
  end

  def handle_call(:view, _from, state) do
    {:reply, state, state}
  end
end
