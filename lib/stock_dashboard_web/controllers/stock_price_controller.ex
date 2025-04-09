defmodule StockDashboardWeb.StockPriceController do
  use StockDashboardWeb, :controller
  alias StockDashboard.Query.Stock

  def new(conn, _params), do: render(conn, :new)

  def create(conn, %{"file" => %Plug.Upload{path: path}}) do
    case StockDashboard.Service.StockPrice.ingest_file(path) do
      :ok ->
        put_flash(conn, :info, "File uploaded and processed successfully.")
        |> redirect(to: ~p"/")

      {:error, reason} ->
        put_flash(conn, :error, "Upload failed: #{reason}")
        |> redirect(to: ~p"/upload")
    end
  end

  def index(conn, %{"symbol" => symbol, "aggregation" => agg}) do
    prices = Stock.aggregate_prices(symbol, agg)
    symbols = Stock.list_unique_symbols()
    IO.inspect(prices, label: "pricres")
    IO.inspect(symbols, label: "symbols")

    render(conn, :index,
      prices: prices,
      symbols: symbols,
      selected_symbol: symbol,
      selected_agg: agg
    )
    |> IO.inspect()
  end

  def index(conn, _params) do
    symbols = Stock.list_unique_symbols()
    render(conn, :index, prices: [], symbols: symbols, selected_symbol: nil, selected_agg: nil)
  end

  def clear(conn, _params) do
    StockDashboard.Query.Stock.clear_all()

    conn
    |> put_flash(:info, "All stock data has been cleared.")
    |> redirect(to: ~p"/upload")
  end
end
