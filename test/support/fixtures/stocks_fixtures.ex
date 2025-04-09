defmodule StockDashboard.Query.StockFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StockDashboard.Query.Stock` context.
  """

  @doc """
  Generate a stock_price.
  """
  def stock_price_fixture(attrs \\ %{}) do
    {:ok, stock_price} =
      attrs
      |> Enum.into(%{})
      |> StockDashboard.Query.Stock.create_stock_price()

    stock_price
  end
end
