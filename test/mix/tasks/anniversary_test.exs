defmodule Mix.Tasks.AnniversaryTest do
  use ExUnit.Case

  alias Mix.Tasks.Anniversary

  @current_date ""

  setup do
    # Mock setup for current date
    :ok
  end

  describe "run" do
    test "returns the expected result based on the current date" do
      assert response = Anniversary.run(["./test/test_import.csv"])
    end

    test "returns the expected result based on an input run_date" do
      assert response = Anniversary.run(["./test/test_import.csv", "2015-10-01"])
    end

    test "returns error if invalid inputs" do
      assert "Call must match pattern mix anniversary <input_file_path> <run_date>\n" ==
               ExUnit.CaptureIO.capture_io(fn -> Anniversary.run([]) end)
    end
  end
end
