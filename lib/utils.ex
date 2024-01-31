defmodule AnniversaryApp.Utils do
  @moduledoc """
  This module contains utility functions to be used across contexts.
  """

  @doc "Determines if the first date is >= the second date based on the month and day only."
  @spec not_past_date?(Date.t(), Date.t()) :: boolean()
  def not_past_date?(%Date{} = first_date, %Date{} = second_date) do
    first_date
    |> Map.put(:year, year(second_date))
    |> Date.compare(second_date)
    |> case do
      :eq -> true
      :gt -> true
      _ -> false
    end
  end

  @doc "Returns the year for the input datae."
  @spec year(Date.t()) :: integer()
  def year(%Date{} = date), do: date.year
end
