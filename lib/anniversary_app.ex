defmodule AnniversaryApp do
  @moduledoc """
  This is a context module exposing functions for handling a CSV input file and producing
  an ordered JSON response.
  """

  alias AnniversaryApp.Employee
  alias AnniversaryApp.FileImporter
  alias AnniversaryApp.Response

  @type supervisor_map :: %{String.t() => list(Employee.t())}

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

  @doc """
  Builds a supervisor map with up to 5 of the supervisors employees with upcoming anniversaries
  in order based on their anniversary date.
  """
  @spec order_data(list(Employee.t()), Date.t()) :: supervisor_map()
  def order_data(employees, %Date{} = run_date) do
    Enum.reduce(employees, %{}, fn employee, acc ->
      acc
      |> Map.put_new(employee.employee_id, [])
      |> Map.put_new(employee.supervisor_id, [])
      |> Map.update(
        employee.supervisor_id,
        [],
        &Employee.maybe_add_employee(&1, employee, run_date)
      )
    end)
  end

  @doc """
  Creates a JSON formatted response matching the output requirements given a
  supervisor map.
  """
  @spec build_response(supervisor_map()) :: String.t()
  def build_response(supervisor_map), do: Response.build_response(supervisor_map)
end
