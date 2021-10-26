defmodule OsrsGePrometheus.ItemSupervisor do
  use Supervisor
  require Logger

  @default_api_url "https://prices.runescape.wiki/api/v1/osrs/mapping"

  @moduledoc """
  Supervisor for all of the ItemServers. Instantiates them by pulling from API
  """

  def init(_args) do
    children =
      get_items()
      |> Enum.map(fn x ->
        %{id: Map.get(x, :id), start: {OsrsGePrometheus.ItemServer, :start_link, [x]}}
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(init_arg \\ []) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Returns the PID of the server from a given item id.
  """
  @spec get_child(integer()) :: {atom, pid}
  def get_child(id) do
    with {_name, pid, _type, _args} <-
           Supervisor.which_children(__MODULE__) |> Enum.find(fn x -> elem(x, 0) == id end) do
      {:ok, pid}
    else
      _ -> {:error, :no_exist}
    end
  end

  defp get_items() do
    Logger.debug("Getting Item Data")
    user_agent = Application.get_env(:osrs_ge_prometheus, :user_agent)
    api_url = Application.get_env(:osrs_ge_prometheus, :item_data_api_url, @default_api_url)
    data = HTTPoison.get!("#{api_url}", [{"User-Agent", user_agent}]) |> Map.get(:body)

    Jason.decode!(data, keys: :atoms)
  end
end
