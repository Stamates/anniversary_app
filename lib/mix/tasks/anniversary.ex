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

  def run([input_file]), do: run([input_file, Date.utc_today()])

  def run([input_file, run_date]) do
    Mix.Task.run("app.start")
    # Import file, parse, and convert to structured format
    # Sort and filter for upcoming anniversaries
    # Build and return JSON payload
    # Handle error messages with invalid input parameters
  end

  def run(_args),
    do: IO.puts("Call must match pattern mix anniversary <input_file_path> <run_date>")
end
