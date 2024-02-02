defmodule Mix.Tasks.AnniversaryTest do
  use ExUnit.Case

  alias AnniversaryApp.CurrentTimeMock
  alias Mix.Tasks.Anniversary

  @current_date ~D[2020-01-01]

  describe "run" do
    test "returns the expected result based on the current date" do
      CurrentTimeMock.update(@current_date)

      assert """
             [
               {
                 \"supervisor_id\": \"ballison200\",
                 \"upcoming_milestones\": [
                   {
                     \"employee_id\": \"sfrost205\",
                     \"anniversary_date\": \"2020-01-29\"
                   }
                 ]
               },
               {
                 \"supervisor_id\": \"lconrad254\",
                 \"upcoming_milestones\": []
               },
               {
                 \"supervisor_id\": \"sfrost205\",
                 \"upcoming_milestones\": []
               },
               {
                 \"supervisor_id\": \"tbriggs201\",
                 \"upcoming_milestones\": []
               },
               {
                 \"supervisor_id\": \"wlee257\",
                 \"upcoming_milestones\": []
               }
             ]
             """ ==
               ExUnit.CaptureIO.capture_io(fn ->
                 Anniversary.run(["./test/test_import.csv"])
               end)
    end

    test "returns the expected result based on an input run_date" do
      assert """
             [
               {
                 \"supervisor_id\": \"ballison200\",
                 \"upcoming_milestones\": [
                   {
                     \"employee_id\": \"sfrost205\",
                     \"anniversary_date\": \"2020-01-29\"
                   }
                 ]
               },
               {
                 \"supervisor_id\": \"lconrad254\",
                 \"upcoming_milestones\": []
               },
               {
                 \"supervisor_id\": \"sfrost205\",
                 \"upcoming_milestones\": []
               },
               {
                 \"supervisor_id\": \"tbriggs201\",
                 \"upcoming_milestones\": []
               },
               {
                 \"supervisor_id\": \"wlee257\",
                 \"upcoming_milestones\": []
               }
             ]
             """ ==
               ExUnit.CaptureIO.capture_io(fn ->
                 Anniversary.run(["./test/test_import.csv", "2020-01-01"])
               end)
    end

    test "returns error if invalid inputs" do
      assert "Call must match pattern mix anniversary <input_file_path> <run_date>\n" ==
               ExUnit.CaptureIO.capture_io(fn -> Anniversary.run([]) end)
    end

    test "returns error if invalid file data" do
      assert "Error on row 2: Row is missing data\n" ==
               ExUnit.CaptureIO.capture_io(fn ->
                 Anniversary.run(["./test/invalid_row_data.csv"])
               end)
    end

    test "returns error if invalid file" do
      assert "File must be a valid CSV file\n" ==
               ExUnit.CaptureIO.capture_io(fn ->
                 Anniversary.run(["./test/invalid.xlsx"])
               end)
    end
  end
end
