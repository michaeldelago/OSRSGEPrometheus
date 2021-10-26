defmodule OsrsGePrometheus.PriceChecker do
  use GenServer
  require Logger

  @default_api_url "https://prices.runescape.wiki/api/v1/osrs/latest/"
  @refresh_every 5

  @moduledoc """
  GenServer that runs at scheduled interval to refresh prices of all items
  """

  def init(args \\ []) do
    send(self(), :update)
    interval = Application.get_env(:osrs_ge_prometheus, :price_check_interval, @refresh_every)
    :timer.send_interval(:timer.minutes(interval), :update)
    {:ok, args}
  end

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
  GenServer Callback that updates the prices for all of the items
  """

  def handle_info(:update, state) do
    Logger.info("Updating GE Prices")
    user_agent = Application.get_env(:osrs_ge_prometheus, :user_agent)
    api_url = Application.get_env(:osrs_ge_prometheus, :prices_api_url, @default_api_url)
    data = HTTPoison.get!(api_url, [{'User-Agent', user_agent}]) |> Map.get(:body)

    item_servers = Supervisor.which_children(OsrsGePrometheus.ItemSupervisor)
      |> Stream.filter(fn {_id, _pid, _type, [module]} -> module == OsrsGePrometheus.ItemServer end)
      |> Stream.map(fn {id, pid, _type, _module} -> {id, pid} end)
      |> Map.new

    Jason.decode!(data)
    |> Map.get("data")
    |> Stream.map(fn {k, v} -> {Integer.parse(k) |> elem(0), v} end)
    |> Enum.each(fn {x, prices} ->
      Map.get(item_servers, x) |> OsrsGePrometheus.ItemServer.set_prices(prices)
    end)

  {:noreply, state}
  end
end
