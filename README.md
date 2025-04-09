# 📈 StockDashboard

StockDashboard is a Phoenix-powered web application to upload, aggregate, and visualize stock prices from TSV files. It includes:

- File upload & validation
- Chart visualization (Chart.js)
- Aggregation (hourly/daily)
- Tailwind CSS for modern UI
- Dockerized, production-ready setup
- Easy deployment to Fly.io / Railway / Gigalixir

---

## 🚀 Features

- ✅ Upload `.tsv` stock data with `symbol`, `timestamp`, `price`
- ✅ View average prices by **hour** or **day**
- ✅ Render beautiful interactive charts (via Chart.js)
- ✅ Fully styled with Tailwind CSS
- ✅ Download sample data template
- ✅ Clear existing data with a single click
- ✅ Handles large files efficiently using streaming + batching
- ✅ Production ready: release config + Dockerfile

---

---

## 🧰 Tech Stack

| Layer        | Technology                     |
|--------------|--------------------------------|
| Language     | Elixir `~> 1.14`               |
| Web Framework | Phoenix `~> 1.7.14`           |
| Live View    | `~> 1.0.0-rc.1`                |
| CSS          | Tailwind CSS (via Mix task)    |
| JS           | Esbuild & Chart.js             |
| DB           | PostgreSQL `>= 13`             |
| Server       | Bandit                         |
| Packaging    | Multi-stage Dockerfile
                                 

# Dockerfile is parially developed But not completed 
---

## 🚀 Live Demo

## 📽️ Demo Video

[![Watch the video](https://img.youtube.com/vi/3W-Uslz2kck/0.jpg)](https://www.youtube.com/watch?v=3W-Uslz2kck)

Click the image above to watch the video on YouTube.


---

## 📦 TSV File Format

Your uploaded `.tsv` must follow this structure:

```tsv
symbol	timestamp	price
AAPL	1680343200	117.45
GOOGL	1680346800	1519.22
TSLA	1680350400	823.75

## 🛠️ Project Setup

To run the app locally:

```bash
# Install Elixir deps
mix deps.get

# Setup the database
mix ecto.setup

# Build assets (esbuild + tailwind)
mix assets.deploy

# Start the Phoenix server
mix phx.server
