defmodule StockDashboard.Repo.Migrations.FixStockPricesColumns do
  use Ecto.Migration

  def change do
    alter table(:stock_prices) do
      remove :"\\"
      add :symbol, :string
      add :timestamp, :utc_datetime
      add :price, :float
    end
  end
end
