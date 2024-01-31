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

  describe "order_data/2" do
    setup do
      employees = [
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
          hire_date: ~D[1996-01-29],
          supervisor_id: "ballison200"
        },
        # Hire date of 1995 so should be excluded from rest of supervisor employees
        %Employee{
          employee_id: "lpierce187",
          first_name: "Lyndon",
          last_name: "Pierce",
          hire_date: ~D[1995-04-29],
          supervisor_id: "ballison200"
        },
        %Employee{
          employee_id: "jrodriguez192",
          first_name: "Javier",
          hire_date: ~D[2001-09-11],
          last_name: "Rodriguez",
          supervisor_id: "ballison200"
        },
        %Employee{
          employee_id: "vstevens199",
          first_name: "Vicenta",
          hire_date: ~D[1991-08-11],
          last_name: "Stevens",
          supervisor_id: "ballison200"
        },
        %Employee{
          employee_id: "restes196",
          first_name: "Rosella",
          hire_date: ~D[1981-07-12],
          last_name: "Estes",
          supervisor_id: "ballison200"
        },
        %Employee{
          employee_id: "cmueller163",
          first_name: "Candra",
          hire_date: ~D[1986-05-12],
          last_name: "Mueller",
          supervisor_id: "ballison200"
        },
        %Employee{
          employee_id: "jbest206",
          first_name: "Jettie",
          hire_date: ~D[1991-12-12],
          last_name: "Best",
          supervisor_id: "ballison200"
        },
        # Hire date in future so should be excluded
        %Employee{
          employee_id: "mcoleman145",
          first_name: "Malorie",
          hire_date: ~D[2026-09-11],
          last_name: "Coleman",
          supervisor_id: "ballison200"
        },
        %Employee{
          employee_id: "ballison200",
          first_name: "Brendon",
          hire_date: ~D[1976-06-12],
          last_name: "Allison",
          supervisor_id: "cbarnett198"
        }
      ]

      [employees: employees]
    end

    test "returns supervisor correct upcoming annivesary list per supervisor", %{
      employees: employees
    } do
      run_date = ~D[2016-02-01]

      assert %{
               "lconrad254" => [
                 %Employee{
                   anniversary_date: ~D[2016-11-19],
                   employee_id: "wlee257",
                   first_name: "Winford",
                   hire_date: ~D[1996-11-19],
                   last_name: "Lee",
                   supervisor_id: "lconrad254"
                 }
               ],
               "ballison200" => [
                 %Employee{
                   anniversary_date: ~D[2016-04-10],
                   employee_id: "tbriggs201",
                   first_name: "Tanya",
                   hire_date: ~D[2006-04-10],
                   last_name: "Briggs",
                   supervisor_id: "ballison200"
                 },
                 %Employee{
                   anniversary_date: ~D[2016-05-12],
                   employee_id: "cmueller163",
                   first_name: "Candra",
                   hire_date: ~D[1986-05-12],
                   last_name: "Mueller",
                   supervisor_id: "ballison200"
                 },
                 %Employee{
                   anniversary_date: ~D[2016-07-12],
                   employee_id: "restes196",
                   first_name: "Rosella",
                   hire_date: ~D[1981-07-12],
                   last_name: "Estes",
                   supervisor_id: "ballison200"
                 },
                 %Employee{
                   anniversary_date: ~D[2016-08-11],
                   employee_id: "vstevens199",
                   first_name: "Vicenta",
                   hire_date: ~D[1991-08-11],
                   last_name: "Stevens",
                   supervisor_id: "ballison200"
                 },
                 %Employee{
                   anniversary_date: ~D[2016-09-11],
                   employee_id: "jrodriguez192",
                   first_name: "Javier",
                   hire_date: ~D[2001-09-11],
                   last_name: "Rodriguez",
                   supervisor_id: "ballison200"
                 }
               ],
               "cbarnett198" => [
                 %Employee{
                   anniversary_date: ~D[2016-06-12],
                   employee_id: "ballison200",
                   first_name: "Brendon",
                   hire_date: ~D[1976-06-12],
                   last_name: "Allison",
                   supervisor_id: "cbarnett198"
                 }
               ],
               "wlee257" => [],
               "mcoleman145" => [],
               "tbriggs201" => [],
               "cmueller163" => [],
               "restes196" => [],
               "vstevens199" => [],
               "jrodriguez192" => [],
               "sfrost205" => [],
               "lpierce187" => [],
               "jbest206" => []
             } == AnniversaryApp.order_data(employees, run_date)
    end

    test "lists change with different date", %{
      employees: employees
    } do
      run_date = ~D[2015-02-01]

      assert %{
               "lconrad254" => [],
               "ballison200" => [
                 %Employee{
                   anniversary_date: ~D[2015-04-29],
                   employee_id: "lpierce187",
                   first_name: "Lyndon",
                   last_name: "Pierce",
                   hire_date: ~D[1995-04-29],
                   supervisor_id: "ballison200"
                 }
               ],
               "cbarnett198" => [],
               "wlee257" => [],
               "mcoleman145" => [],
               "tbriggs201" => [],
               "cmueller163" => [],
               "restes196" => [],
               "vstevens199" => [],
               "jrodriguez192" => [],
               "sfrost205" => [],
               "lpierce187" => [],
               "jbest206" => []
             } == AnniversaryApp.order_data(employees, run_date)
    end
  end
end
