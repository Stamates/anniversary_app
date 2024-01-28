defmodule AnniversaryApp do
  @moduledoc """
  This is a context module exposing functions for handling a CSV input file and producing
  an ordered JSON response.
  """

  alias AnniversaryApp.Employee
  alias AnniversaryApp.FileImporter

  @doc "Converts a CSV input file into a list of Employees unless there's an error"
  @spec get_employees(String.t()) ::
          {:ok, list(Employee.t())} | {:error, list(map() | String.t())}
  def get_employees(input_file) do
    input_file
    |> FileImporter.parse_import()
    |> FileImporter.transform_data()
    |> case do
      %{successes: employees, errors: []} -> {:ok, employees}
      %{errors: errors} -> {:error, errors}
    end
  end

  @doc "Orders upcoming anniversaries based on the run_date and returns a structured result"
  @spec order_data(list(Employee.t()), Date.t()) ::
          {:ok, map()} | {:error, list(String.t())}
  def order_data(employees, run_date) do
    {:ok, %{}}
  end
end
