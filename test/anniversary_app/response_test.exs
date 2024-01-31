defmodule AnniversaryApp.ResponseTest do
  use ExUnit.Case

  alias AnniversaryApp.Employee
  alias AnniversaryApp.Response

  describe "build/1" do
    setup do
      %{
        supervisor_map: %{
          "lconrad254" => [
            %Employee{
              employee_id: "wlee257",
              first_name: "Winford",
              last_name: "Lee",
              hire_date: ~D[1996-11-19],
              supervisor_id: "lconrad254"
            }
          ],
          "ballison200" => [
            %Employee{
              employee_id: "tbriggs201",
              first_name: "Tanya",
              hire_date: ~D[2006-04-10],
              last_name: "Briggs",
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
              employee_id: "restes196",
              first_name: "Rosella",
              hire_date: ~D[1981-07-12],
              last_name: "Estes",
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
              employee_id: "jrodriguez192",
              first_name: "Javier",
              hire_date: ~D[2001-09-11],
              last_name: "Rodriguez",
              supervisor_id: "ballison200"
            }
          ],
          "cbarnett198" => [
            %Employee{
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
        }
      }
    end

    test "build returns a JSON formatted response", %{supervisor_map: supervisor_map} do
      assert [
               %{
                 "supervisor_id" => "ballison200",
                 "upcoming_milestones" => [
                   %{employee_id: "tbriggs201", anniversary_date: nil},
                   %{employee_id: "cmueller163", anniversary_date: nil},
                   %{employee_id: "restes196", anniversary_date: nil},
                   %{employee_id: "vstevens199", anniversary_date: nil},
                   %{employee_id: "jrodriguez192", anniversary_date: nil}
                 ]
               },
               %{
                 "supervisor_id" => "cbarnett198",
                 "upcoming_milestones" => [%{employee_id: "ballison200", anniversary_date: nil}]
               },
               %{"supervisor_id" => "cmueller163", "upcoming_milestones" => []},
               %{"supervisor_id" => "jbest206", "upcoming_milestones" => []},
               %{"supervisor_id" => "jrodriguez192", "upcoming_milestones" => []},
               %{
                 "supervisor_id" => "lconrad254",
                 "upcoming_milestones" => [%{employee_id: "wlee257", anniversary_date: nil}]
               },
               %{"supervisor_id" => "lpierce187", "upcoming_milestones" => []},
               %{"supervisor_id" => "mcoleman145", "upcoming_milestones" => []},
               %{"supervisor_id" => "restes196", "upcoming_milestones" => []},
               %{"supervisor_id" => "sfrost205", "upcoming_milestones" => []},
               %{"supervisor_id" => "tbriggs201", "upcoming_milestones" => []},
               %{"supervisor_id" => "vstevens199", "upcoming_milestones" => []},
               %{"supervisor_id" => "wlee257", "upcoming_milestones" => []}
             ] == Response.build(supervisor_map)
    end
  end
end
