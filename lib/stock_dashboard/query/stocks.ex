defmodule StockDashboard.Query.Stock do
  @moduledoc """
  The Stock context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias StockDashboard.Repo

  alias StockDashboard.Shema.StockPrice

  @doc """
  Returns the list of stock_prices.

  ## Examples

      iex> list_stock_prices()
      [%StockPrice{}, ...]

  """
  def list_stock_prices do
    Repo.all(StockPrice)
  end

  @doc """
  Gets a single stock_price.

  Raises `Ecto.NoResultsError` if the Stock price does not exist.

  ## Examples

      iex> get_stock_price!(123)
      %StockPrice{}

      iex> get_stock_price!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock_price!(id), do: Repo.get!(StockPrice, id)

  @doc """
  Creates a stock_price.

  ## Examples

      iex> create_stock_price(%{field: value})
      {:ok, %StockPrice{}}

      iex> create_stock_price(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock_price(attrs \\ %{}) do
    %StockPrice{}
    |> StockPrice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stock_price.

  ## Examples

      iex> update_stock_price(stock_price, %{field: new_value})
      {:ok, %StockPrice{}}

      iex> update_stock_price(stock_price, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock_price(%StockPrice{} = stock_price, attrs) do
    stock_price
    |> StockPrice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stock_price.

  ## Examples

      iex> delete_stock_price(stock_price)
      {:ok, %StockPrice{}}

      iex> delete_stock_price(stock_price)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock_price(%StockPrice{} = stock_price) do
    Repo.delete(stock_price)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock_price changes.

  ## Examples

      iex> change_stock_price(stock_price)
      %Ecto.Changeset{data: %StockPrice{}}

  """
  def change_stock_price(%StockPrice{} = stock_price, attrs \\ %{}) do
    StockPrice.changeset(stock_price, attrs)
  end

  @doc "Deletes all stock data"
  def clear_all, do: Repo.delete_all(StockDashboard.Shema.StockPrice)

  @doc """
  Returns a list of all unique stock symbols, ordered alphabetically.
  """

  def list_unique_symbols do
    from(
      s in StockPrice,
      distinct: true,
      select: s.symbol
    )
    |> Repo.all()
  end

  @doc """
  Aggregates average stock prices per hour for a given stock symbol.

  ## Parameters

    - `symbol`: The stock symbol to aggregate data for (e.g., `"AAPL"`).
    - `"hour"`: Fixed string specifying the aggregation interval.

  ## Returns

    A list of tuples `{hour_string, avg_price}`, where `hour_string` is
    formatted as `"YYYY-MM-DD HH24:00"`.
  """
  def aggregate_prices(symbol, "hour") do
    from(
      s in StockPrice,
      where: s.symbol == ^symbol,
      group_by: fragment("date_trunc('hour', ?)", s.timestamp),
      order_by: fragment("date_trunc('hour', ?)", s.timestamp),
      select: {
        fragment("TO_CHAR(date_trunc('hour', ?), 'YYYY-MM-DD HH24:00')", s.timestamp),
        avg(s.price)
      }
    )
    |> Repo.all()
  end

  def aggregate_prices(symbol, "day") do
    from(
      s in StockPrice,
      where: s.symbol == ^symbol,
      group_by: fragment("date_trunc('day', ?)", s.timestamp),
      order_by: fragment("date_trunc('day', ?)", s.timestamp),
      select: {
        fragment("TO_CHAR(date_trunc('day', ?), 'YYYY-MM-DD')", s.timestamp),
        avg(s.price)
      }
    )
    |> Repo.all()
  end
end
