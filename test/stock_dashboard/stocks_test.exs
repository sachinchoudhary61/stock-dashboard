defmodule StockDashboard.Query.StockTest do
  use StockDashboard.DataCase

  alias StockDashboard.Query.Stock

  describe "stock_prices" do
    alias StockDashboard.Shema.StockPrice

    import StockDashboard.Query.StockFixtures

    @invalid_attrs %{\\: nil}

    test "list_stock_prices/0 returns all stock_prices" do
      stock_price = stock_price_fixture()
      assert Stock.list_stock_prices() == [stock_price]
    end

    test "get_stock_price!/1 returns the stock_price with given id" do
      stock_price = stock_price_fixture()
      assert Stock.get_stock_price!(stock_price.id) == stock_price
    end

    test "create_stock_price/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stock.create_stock_price(@invalid_attrs)
    end

    test "update_stock_price/2 with valid data updates the stock_price" do
      stock_price = stock_price_fixture()
      update_attrs = %{\\: "some updated \\"}

      assert {:ok, %StockPrice{} = stock_price} =
               Stock.update_stock_price(stock_price, update_attrs)
    end

    test "update_stock_price/2 with invalid data returns error changeset" do
      stock_price = stock_price_fixture()
      assert {:error, %Ecto.Changeset{}} = Stock.update_stock_price(stock_price, @invalid_attrs)
      assert stock_price == Stock.get_stock_price!(stock_price.id)
    end

    test "delete_stock_price/1 deletes the stock_price" do
      stock_price = stock_price_fixture()
      assert {:ok, %StockPrice{}} = Stock.delete_stock_price(stock_price)
      assert_raise Ecto.NoResultsError, fn -> Stock.get_stock_price!(stock_price.id) end
    end

    test "change_stock_price/1 returns a stock_price changeset" do
      stock_price = stock_price_fixture()
      assert %Ecto.Changeset{} = Stock.change_stock_price(stock_price)
    end
  end
end
