defmodule StockDashboard.Service.StockPrice do
  @moduledoc """
  High-performance ingestion module for TSV stock price data.
  Through this module u can upload 60 MB file in 10 sec. ! ! (Tested)
  Features:
  - Streams files efficiently using `File.stream!/3`
  - Skips optional headers
  - Validates and parses each line
  - Batches inserts using `Repo.insert_all/3`
  - Uses `Task.async_stream/3` for parallel processing of batches
  """

  alias StockDashboard.Repo
  alias StockDashboard.Shema.StockPrice

  @batch_size 1000
  @max_concurrency 10

  @doc """
  Ingests a TSV file and inserts valid rows into the database.

  Returns:
  - `:ok` if all rows were successfully processed
  - `{:error, reason}` if any row fails validation or parsing
  """
  def ingest_file(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> maybe_skip_header()
    |> Stream.chunk_every(@batch_size)
    |> Task.async_stream(&ingest_batch/1, max_concurrency: @max_concurrency, timeout: :infinity)
    |> Enum.reduce_while(:ok, fn
      {:ok, :ok}, acc -> {:cont, acc}
      {:ok, {:error, reason}}, _ -> {:halt, {:error, reason}}
      {:exit, reason}, _ -> {:halt, {:error, inspect(reason)}}
    end)
  end

  defp maybe_skip_header(stream) do
    Stream.transform(stream, :first_line, fn
      line, :first_line ->
        if String.downcase(line) =~ ~r/symbol.*timestamp.*price/ do
          {[], nil}
        else
          {[line], nil}
        end

      line, nil ->
        {[line], nil}
    end)
  end

  defp ingest_batch(lines) do
    {rows, errors} =
      Enum.reduce(lines, {[], []}, fn line, {valid, invalid} ->
        case parse_line(line) do
          {:ok, row} -> {[row | valid], invalid}
          {:error, err} -> {valid, [err | invalid]}
        end
      end)

    case errors do
      [] ->
        Repo.insert_all(StockPrice, Enum.reverse(rows))
        :ok

      [first_error | _] ->
        {:error, first_error}
    end
  end

  defp parse_line(line) do
    case String.split(line, "\t") do
      [symbol, timestamp_str, price_str] ->
        with {:ok, timestamp} <- parse_timestamp(timestamp_str),
             {:ok, price} <- parse_price(price_str) do
          {:ok,
           %{
             symbol: String.trim(symbol),
             timestamp: timestamp,
             price: price,
             inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
             updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
           }}
        else
          {:error, msg} -> {:error, "#{msg} in line: #{line}"}
        end

      _ ->
        {:error, "Malformed line (expected 3 tab-separated values): #{line}"}
    end
  end

  defp parse_timestamp(str) do
    str
    |> String.trim()
    |> String.to_integer()
    |> DateTime.from_unix()
    |> case do
      {:ok, dt} -> {:ok, dt}
      _ -> {:error, "Invalid timestamp: #{str}"}
    end
  rescue
    ArgumentError -> {:error, "Invalid timestamp format: #{str}"}
  end

  defp parse_price(str) do
    case Float.parse(String.trim(str)) do
      {price, ""} -> {:ok, price}
      _ -> {:error, "Invalid price: #{str}"}
    end
  end
end
