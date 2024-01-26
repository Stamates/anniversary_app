defmodule AnniversaryApp.Employee do
  @moduledoc """
  Employee data struct
  """

  use TypedStruct

  typedstruct do
    field(:employee_id, String.t())
    field(:first_name, String.t())
    field(:last_name, String.t())
    field(:hire_date, Date.t())
    field(:supervisor_id, String.t())
  end
end
