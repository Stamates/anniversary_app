defmodule AnniversaryApp.FileImporterTest do
  use ExUnit.Case

  alias AnniversaryApp.FileImporter

  describe "parse_import/1" do
    test "will parse a CSV file and return structured data" do
      assert [header | employees] =
               FileImporter.parse_import("./test/test_import.csv")

      assert {:ok, ["employee_id", "first_name", "last_name", "hire_date", "supervisor_id"]} ==
               header

      assert {:ok, ["sfrost205", "Seema", "Frost", "1995-01-29", "ballison200"]} == hd(employees)
    end

    test "returns an error message if file format is invalid" do
      assert "File must be a valid CSV file" == FileImporter.parse_import("./test/invalid.xlsx")
    end

    test "returns an error message if file not found" do
      assert "File not found" == FileImporter.parse_import("non_existent.csv")
    end
  end
end
