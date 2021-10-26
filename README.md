# OsrsGePrometheus

This is a Prometheus Exporter for the Old School Runescape grand exchange. It was primarily written as a toy to check out how the "prometheus_ex" libraries for Elixir work.

## Docker 

Look over the `docker-compose.yaml` file, and run `docker-compose up`. This will start up basic containers for:

1. This application
2. Prometheus collecting data from this exporter
3. Grafana to toy around with the metrics

## Development

To start:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.