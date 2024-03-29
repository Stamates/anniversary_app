defmodule Mix.Tasks.Anniversary do
  @moduledoc """
  This task will import employee anniversary CSV file and output a JSON response with
  lists of the next 5 anniversaries (based on the provided run_date or current_date default)
  for each supervisor.

  Example:
  `mix anniversary ./test/test_import.csv 2015-10-01`

  Result:
  {
    "supervisor_id": "0028356",
    "upcoming_milestones": [
      {
      "employee_id": "0018325",
      "anniversary_date": "2015-10-03"
      },
      {
      "employee_id": "0038576",
      "anniversary_date": "2015-10-05"
      },
      {
      "employee_id": "0038679",
      "anniversary_date": "2015-10-05"
      },
      {
      "employee_id": "0029385",
      "anniversary_date": "2015-10-17"
      },
      {
      "employee_id": "0066839",
      "anniversary_date": "2015-10-22"
      }
    ]
  }
  """

  use Mix.Task

  alias AnniversaryApp
  alias AnniversaryApp.CurrentTime

  @doc """
  Parses an employee CSV file and produces a supervisor list with any emplyees
  with an upcoming anniversary
  """
  @impl Mix.Task
  def run([input_file]), do: run([input_file, CurrentTime.utc_today() |> Date.to_iso8601()])

  def run([input_file, run_date]) do
    with {:ok, run_date} <- Date.from_iso8601(run_date),
         {:ok, employees} <- AnniversaryApp.get_employees(input_file) do
      employees
      |> AnniversaryApp.order_data(run_date)
      |> AnniversaryApp.build_response()
      |> Jason.encode_to_iodata!()
      |> Jason.Formatter.pretty_print()
      |> IO.puts()
    else
      {:error, errors} -> handle_errors(errors)
    end
  end

  def run(_args),
    do: IO.puts("Call must match pattern mix anniversary <input_file_path> <run_date>")

  defp handle_errors(errors) do
    errors
    |> build_error()
    |> List.to_string()
    |> IO.puts()
  end

  defp build_error([]), do: ""

  defp build_error([%{row: row, error: error} | tail]) do
    ["Error on row #{row}: #{error}" | build_error(tail)]
  end

  defp build_error([error_message]), do: [error_message]
  defp build_error(error_message), do: [error_message]
end
