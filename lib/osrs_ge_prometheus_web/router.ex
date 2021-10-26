defmodule OsrsGePrometheusWeb.Router do
  use OsrsGePrometheusWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OsrsGePrometheusWeb do
    pipe_through :api
  end
end
