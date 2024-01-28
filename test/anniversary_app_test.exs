defmodule AnniversaryAppTest do
  use ExUnit.Case

  alias AnniversaryApp
  alias AnniversaryApp.Employee

  describe "get_employees/1" do
    test "returns an :ok tuple with the employee list if valid input" do
      assert {:ok,
              [
                %Employee{
                  employee_id: "wlee257",
                  first_name: "Winford",
                  last_name: "Lee",
                  hire_date: ~D[1996-11-19],
                  supervisor_id: "lconrad254"
                },
                %Employee{
                  employee_id: "tbriggs201",
                  first_name: "Tanya",
                  hire_date: ~D[2006-04-10],
                  last_name: "Briggs",
                  supervisor_id: "ballison200"
                },
                %Employee{
                  employee_id: "sfrost205",
                  first_name: "Seema",
                  last_name: "Frost",
                  hire_date: ~D[1995-01-29],
                  supervisor_id: "ballison200"
                }
              ]} == AnniversaryApp.get_employees("./test/test_import.csv")
    end

    test "returns an :error tuple if invalid input" do
      assert {:error,
              [
                %{row: 2, error: "Row is missing data"}
              ]} == AnniversaryApp.get_employees("./test/invalid_row_data.csv")
    end
  end
end
