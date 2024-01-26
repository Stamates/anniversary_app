defmodule AnniversaryApp.FileImporter do
  @moduledoc """
  This module contains functions for importing, parsing, and structuring an employee
  anniversary CSV file.
  """

  alias AnniversaryApp.Employee

  @doc """
    Imports a CSV file and decodes the data
  """
  @spec parse_import(String.t()) :: list(tuple())
  def parse_import(input_file_path) do
    input_file_path
    |> File.stream!()
    |> CSV.decode()
    |> Enum.to_list()
    |> verify_valid_import()
  rescue
    _ -> [{:error, "File not found"}]
  end

  @doc """
    Converts CSV output data to a map with list of successful Employee imports and a list
    of any errors.
  """
  @spec transform_data(list(tuple())) :: %{
          successes: list(Employee.t()),
          errors: list(map() | String.t())
        }
  def transform_data([{:ok, header_row} | data_tuples]) do
    data_tuples
    |> Enum.with_index()
    |> Enum.reduce(%{successes: [], errors: []}, fn {row_data, index}, acc ->
      row_data
      |> maybe_transform_data(header_row, index)
      |> case do
        {:error, error} -> %{acc | errors: [error | acc.errors]}
        {:ok, employee} -> %{acc | successes: [employee | acc.successes]}
      end
    end)
  catch
    error -> %{successes: [], errors: [error]}
  end

  def transform_data([{:error, error}]), do: %{successes: [], errors: [error]}

  defp convert_to_struct(%{} = employee_map, _) do
    {:ok, struct(%Employee{}, employee_map)}
  end

  defp convert_to_struct(error_message, index),
    do: {:error, %{row: index + 1, error: error_message}}

  defp maybe_convert_value(:hire_date, date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> date
      {:error, error} -> raise(error)
    end
  end

  defp maybe_convert_value(_, value), do: value

  defp maybe_transform_data({:ok, data}, header_row, index) do
    header_row
    |> Enum.zip(data)
    |> Enum.into(%{})
    |> validate_map()
    |> sanitize_data()
    |> convert_to_struct(index)
  end

  defp maybe_transform_data({:error, data}, _header_row, index) do
    {:error, %{row: index + 1, error: data}}
  end

  defp sanitize_data(%{} = employee_map) do
    for {key, val} <- employee_map, into: %{} do
      key_atom = String.to_existing_atom(key)
      {key_atom, maybe_convert_value(key_atom, val)}
    end
  rescue
    ArgumentError -> throw("Invalid header row provided")
    _ -> "Invalid hire date provided"
  end

  defp sanitize_data(error), do: error

  defp validate_map(employee_map) do
    if employee_map |> Map.keys() |> length() ==
         %Employee{} |> Map.delete(:__struct__) |> Map.keys() |> length() do
      employee_map
    else
      "Row is missing data"
    end
  end

  defp verify_valid_import([{:ok, headers} | _employees] = data) when is_list(headers), do: data
  defp verify_valid_import(_), do: [{:error, "File must be a valid CSV file"}]
end
