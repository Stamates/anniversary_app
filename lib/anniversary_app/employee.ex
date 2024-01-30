defmodule AnniversaryApp.Employee do
  @moduledoc """
  Employee data struct
  """

  use TypedStruct

  alias AnniversaryApp.Utils

  @anniversary_year 5
  @employee_list_limit 5

  typedstruct do
    field(:employee_id, String.t())
    field(:first_name, String.t())
    field(:last_name, String.t())
    field(:hire_date, Date.t())
    field(:supervisor_id, String.t())
  end

  @doc """
  Determines if an employee should be added to an employee list based on being in the set
  number of employees with an upcomoing anniversary.
  """
  @spec maybe_add_employee(list(t()), t(), Date.t()) :: list(t())
  def maybe_add_employee(supervisor_employee_list, employee, run_date) do
    if upcoming_anniversary?(employee, run_date) do
      supervisor_employee_list |> add_employee(employee) |> Enum.take(@employee_list_limit)
    else
      supervisor_employee_list
    end
  end

  @doc """
  Get upcoming anniversary from employee
  """
  @spec upcoming_anniversary?(t(), Date.t()) :: boolean()
  def upcoming_anniversary?(employee, run_date) do
    with true <- Utils.year(employee.hire_date) < Utils.year(run_date),
         0 <-
           Integer.mod(Utils.year(employee.hire_date) - Utils.year(run_date), @anniversary_year),
         true <- Utils.not_past_date?(employee.hire_date, run_date) do
      true
    else
      _ -> false
    end
  end

  defp add_employee([], employee), do: [employee]

  defp add_employee([head | tail], employee) do
    if Utils.not_past_date?(head.hire_date, employee.hire_date) do
      [employee, head] ++ tail
    else
      [head | add_employee(tail, employee)]
    end
  end
end
