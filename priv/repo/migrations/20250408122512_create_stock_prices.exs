defmodule StockDashboard.Repo.Migrations.CreateStockPrices do
  use Ecto.Migration

  def change do
    create table(:stock_prices) do
      add :"\\", :string

      timestamps(type: :utc_datetime)
    end
  end
end
