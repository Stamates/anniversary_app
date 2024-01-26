defmodule AnniversaryApp.FileImporterTest do
  use ExUnit.Case

  alias AnniversaryApp.Employee
  alias AnniversaryApp.FileImporter

  describe "parse_import/1" do
    test "will parse a CSV file and return structured data" do
      assert [header | employees] =
               FileImporter.parse_import("./test/test_import.csv")

      assert {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]} ==
               header

      assert {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]} == hd(employees)
    end

    test "will accept if row is missing data" do
      assert [
               {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]},
               {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]},
               {:ok, ["tbriggs201", "Tanya", "Briggs", "2006-04-10"]},
               {:ok, ["drutledge166", "Dayle", "Rutledge", "1993-01-25", "jbrady157"]}
             ] ==
               FileImporter.parse_import("./test/invalid_row_data.csv")
    end

    test "returns an error message if file format is invalid" do
      assert [{:error, "File must be a valid CSV file"}] ==
               FileImporter.parse_import("./test/invalid.xlsx")
    end

    test "returns an error message if file not found" do
      assert [{:error, "File not found"}] == FileImporter.parse_import("non_existent.csv")
    end
  end

  describe "transform_data/1" do
    test "converts csv data into list of tuples with Employee records" do
      assert %{
               successes: [
                 %Employee{
                   employee_id: "wlee257",
                   first_name: "Winford",
                   last_name: "Lee",
                   hire_date: ~D[1996-11-19],
                   supervisor_id: "lconrad254"
                 },
                 %Employee{
                   employee_id: "sfrost205",
                   first_name: "Seema",
                   last_name: "Frost",
                   hire_date: ~D[1995-01-29],
                   supervisor_id: "ballison200"
                 }
               ],
               errors: []
             } ==
               FileImporter.transform_data([
                 {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]},
                 {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]},
                 {:ok, ["wlee257", "Winford", "Lee", "1996-11-19", "lconrad254"]}
               ])
    end

    test "missing data returns an error" do
      assert %{
               successes: [
                 %Employee{
                   employee_id: "wlee257",
                   first_name: "Winford",
                   last_name: "Lee",
                   hire_date: ~D[1996-11-19],
                   supervisor_id: "lconrad254"
                 },
                 %Employee{
                   employee_id: "sfrost205",
                   first_name: "Seema",
                   last_name: "Frost",
                   hire_date: ~D[1995-01-29],
                   supervisor_id: "ballison200"
                 }
               ],
               errors: [%{row: 2, error: "Row is missing data"}]
             } ==
               FileImporter.transform_data([
                 {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]},
                 {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]},
                 {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29"]},
                 {:ok, ["wlee257", "Winford", "Lee", "1996-11-19", "lconrad254"]}
               ])
    end

    test "includes row and data for any errors" do
      assert %{
               successes: [
                 %Employee{
                   employee_id: "sfrost205",
                   first_name: "Seema",
                   last_name: "Frost",
                   hire_date: ~D[1995-01-29],
                   supervisor_id: "ballison200"
                 }
               ],
               errors: [%{row: 2, error: "Something's wrong"}]
             } ==
               FileImporter.transform_data([
                 {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]},
                 {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]},
                 {:error, "Something's wrong"}
               ])
    end

    test "adds error if hire_date is malformed" do
      assert %{
               successes: [],
               errors: [%{row: 1, error: "Invalid hire date provided"}]
             } ==
               FileImporter.transform_data([
                 {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]},
                 {:ok, ["sfrost205", "Seema", "Frost", "01-29-1995", "ballison200"]}
               ])
    end

    test "responds with error if header row is malformed" do
      assert %{successes: [], errors: ["Invalid header row provided"]} ==
               FileImporter.transform_data([
                 {:ok, ["employee_id", "first_name", "last_name", "hire_date", "garbage"]},
                 {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]}
               ])
    end

    test "handles file import error" do
      assert %{successes: [], errors: ["File not found"]} ==
               FileImporter.transform_data([{:error, "File not found"}])
    end
  end
end
