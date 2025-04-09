defmodule StockDashboardWeb.StockPriceHTML do
  use StockDashboardWeb, :html
  # ✅ Add this to bring in form_tag/3, submit/1, etc.

  embed_templates "stock_price_html/*"
end
