defmodule OsrsGePrometheus.Supervisor do
  use Supervisor

  def init(__args) do
    children = [
      {OsrsGePrometheus.ItemSupervisor,     []},
      {OsrsGePrometheus.PriceChecker, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(init_arg \\ []) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end
end
