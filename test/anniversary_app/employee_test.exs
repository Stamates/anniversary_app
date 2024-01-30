defmodule AnniversaryApp.EmployeeTest do
  use ExUnit.Case

  alias AnniversaryApp.Employee

  describe "maybe_add_employee/3" do
    test "adds employee to list if upcoming anniversary" do
      assert [%Employee{hire_date: ~D[2010-02-01]}] =
               Employee.maybe_add_employee(
                 [],
                 %Employee{hire_date: ~D[2010-02-01]},
                 ~D[2015-02-01]
               )
    end

    test "adds employee to proper order in list and truncates to list limit" do
      list = [
        %Employee{hire_date: ~D[2010-02-01]},
        %Employee{hire_date: ~D[2000-03-11]},
        %Employee{hire_date: ~D[2010-05-01]},
        %Employee{hire_date: ~D[1995-07-21]},
        %Employee{hire_date: ~D[2005-08-07]}
      ]

      assert [
               %Employee{hire_date: ~D[2010-02-01]},
               %Employee{hire_date: ~D[2000-03-11]},
               %Employee{hire_date: ~D[2010-04-03]},
               %Employee{hire_date: ~D[2010-05-01]},
               %Employee{hire_date: ~D[1995-07-21]}
             ] =
               Employee.maybe_add_employee(
                 list,
                 %Employee{hire_date: ~D[2010-04-03]},
                 ~D[2015-02-01]
               )
    end

    test "does NOT add employee if they are beyond the list limit" do
      list = [
        %Employee{hire_date: ~D[2010-02-01]},
        %Employee{hire_date: ~D[2000-03-11]},
        %Employee{hire_date: ~D[2010-05-01]},
        %Employee{hire_date: ~D[1995-07-21]},
        %Employee{hire_date: ~D[2005-08-07]}
      ]

      assert [
               %Employee{hire_date: ~D[2010-02-01]},
               %Employee{hire_date: ~D[2000-03-11]},
               %Employee{hire_date: ~D[2010-05-01]},
               %Employee{hire_date: ~D[1995-07-21]},
               %Employee{hire_date: ~D[2005-08-07]}
             ] =
               Employee.maybe_add_employee(
                 list,
                 %Employee{hire_date: ~D[2010-09-03]},
                 ~D[2015-02-01]
               )
    end

    test "does NOT add employee if not in an anniversary year" do
      assert [] ==
               Employee.maybe_add_employee(
                 [],
                 %Employee{hire_date: ~D[2010-02-01]},
                 ~D[2016-02-01]
               )
    end

    test "does NOT add employee if anniversary date is before month/day of run_date" do
      assert [] ==
               Employee.maybe_add_employee(
                 [],
                 %Employee{hire_date: ~D[2010-01-01]},
                 ~D[2015-02-01]
               )
    end

    test "does NOT add employee if their hire_date year is >= run_date year" do
      assert [] ==
               Employee.maybe_add_employee(
                 [],
                 %Employee{hire_date: ~D[2015-04-01]},
                 ~D[2015-02-01]
               )

      assert [] ==
               Employee.maybe_add_employee(
                 [],
                 %Employee{hire_date: ~D[2025-04-01]},
                 ~D[2015-02-01]
               )
    end
  end

  describe "upcoming_anniversary/2" do
    test "returns true if anniversary year and month/day >= run_date" do
      assert Employee.upcoming_anniversary?(%Employee{hire_date: ~D[2010-02-01]}, ~D[2015-02-01])
    end

    test "returns false if hire_date year is not an anniversary year" do
      refute Employee.upcoming_anniversary?(%Employee{hire_date: ~D[2026-03-01]}, ~D[2015-02-01])
    end

    test "returns false if hire_date year is same as run_date" do
      refute Employee.upcoming_anniversary?(%Employee{hire_date: ~D[2015-03-01]}, ~D[2015-02-01])
    end

    test "returns false if same year as anniversary year but before run_date" do
      refute Employee.upcoming_anniversary?(%Employee{hire_date: ~D[2010-01-01]}, ~D[2015-02-01])
    end
  end
end
