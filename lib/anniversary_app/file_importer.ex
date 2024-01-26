defmodule AnniversaryApp.FileImporter do
  @moduledoc """
  This module contains functions for importing, parsing, and structuring an employee
  anniversary CSV file.
  """

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
    _ -> "File not found"
  end

  defp verify_valid_import([{:ok, headers} | _employees] = data) when is_list(headers), do: data
  defp verify_valid_import(_), do: "File must be a valid CSV file"
end
