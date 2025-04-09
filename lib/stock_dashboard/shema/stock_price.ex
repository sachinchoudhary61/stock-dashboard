defmodule StockDashboard.Shema.StockPrice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stock_prices" do
    field :symbol, :string
    field :timestamp, :utc_datetime
    field :price, :float

    timestamps()
  end

  def changeset(stock_price, attrs) do
    stock_price
    |> cast(attrs, [:symbol, :timestamp, :price])
    |> validate_required([:symbol, :timestamp, :price])
  end
end
