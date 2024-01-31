defmodule AnniversaryApp.Response do
  @moduledoc """
  This module contains functions building a response payload with
  upcoming anniversaries per supervisor.
  """

  @doc """
  Creates a response list matching the output requirements given a supervisor map.
  """
  @spec build(AnniversaryApp.supervisor_map()) :: list(map())
  def build(supervisor_map), do: Enum.map(supervisor_map, &build_supervisor_data/1)

  defp build_supervisor_data({supervisor_id, employees}) do
    %{
      "supervisor_id" => supervisor_id,
      "upcoming_milestones" =>
        Enum.map(employees, &Map.take(&1, [:employee_id, :anniversary_date]))
    }
  end
end
