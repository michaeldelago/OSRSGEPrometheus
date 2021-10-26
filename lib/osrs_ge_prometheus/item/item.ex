defmodule OsrsGePrometheus.Item do
  require Logger

  defstruct id: -1,
            name: "",
            examine: "",
            limit: -1,
            highalch: -1,
            lowalch: -1,
            ge_hi: -1,
            ge_lo: -1,
            last_update: -1,
            volume: -1

  @moduledoc """
  Struct representing an item.map()

  Contains functions for setting the price, and checking the high alch profit of an item
  """

  @doc """
  Create new instance of the struct. Inserts a timestamp to the
  """
  @spec new(map) :: %OsrsGePrometheus.Item{}
  def new(input \\ %{}) when is_map(input) do
    struct(__MODULE__, input) |> Map.put(:last_update, DateTime.to_unix(DateTime.now!("Etc/UTC")))
  end

  @doc """
  Set GE price for an instance of an Item. Requires the item, the high, and the low price
  """
  @spec set_ge(%OsrsGePrometheus.Item{}, integer(), integer()) :: %OsrsGePrometheus.Item{}
  def set_ge(%__MODULE__{} = item, hi, lo) do
    %{item | :ge_hi => hi, :ge_lo => lo}
  end

  def set_ge(nil, _, _), do: %__MODULE__{}


  @doc """
  Updates the timestamp of the provided instance
  """
  @spec update_time(%OsrsGePrometheus.Item{}) :: %OsrsGePrometheus.Item{}
  def update_time(%__MODULE__{} = item) do
    item |> Map.put(:last_update, DateTime.to_unix(DateTime.now!("Etc/UTC")))
  end

  @doc """
  Returns the range in values
  """
  @spec range(%OsrsGePrometheus.Item{}) :: integer()
  def range(%__MODULE__{:ge_hi => nil}), do: 0
  def range(%__MODULE__{:ge_lo => nil}), do: 0
  def range(%__MODULE__{:ge_hi => hi, :ge_lo => lo}) do
    hi - lo
  end

  @doc """
  Returns the high alch profit. Requires the item, and the price of a nature rune. 
  """
  @spec high_alch_profit(%OsrsGePrometheus.Item{}, integer()) :: integer()
  def high_alch_profit(%__MODULE__{:highalch => nil}, _nat_price), do: 0
  def high_alch_profit(%__MODULE__{:ge_lo => nil}, _nat_price), do: 0
  def high_alch_profit(%__MODULE__{:ge_lo => ge_lo}, _nat_price) when ge_lo < 0, do: 0
  def high_alch_profit(%__MODULE__{} = item, nat_price) when is_integer(nat_price) do
    ge_avg = (Map.get(item, :ge_lo, 0) + Map.get(item, :ge_hi, 0)) / 2

    Map.get(item, :highalch, 0) - (ge_avg + nat_price)
  end
end
