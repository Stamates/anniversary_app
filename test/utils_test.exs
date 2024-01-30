defmodule AnniversaryApp.UtilsTest do
  use ExUnit.Case

  alias AnniversaryApp.Utils

  describe "not_past_date?/2" do
    test "returns true if first date is >= the month/day of the second date" do
      assert Utils.not_past_date?(~D[2010-02-01], ~D[2000-02-01])
    end

    test "returns false if first date is <>=> the month/day of the second date" do
      refute Utils.not_past_date?(~D[2010-01-01], ~D[2000-02-01])
    end
  end

  describe "year/1" do
    test "returns the year for the input date" do
      assert 2010 == Utils.year(~D[2010-02-01])
    end

    test "returns another year for the input date" do
      assert 2012 == Utils.year(~D[2012-03-01])
    end
  end
end
