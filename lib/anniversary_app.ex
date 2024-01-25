defmodule AnniversaryApp do
  @moduledoc """
  This is a context module exposing functions for handling a CSV input file and producing
  an ordered JSON response.
  """

  @doc "Converts a CSV input file into a structured data"
  @spec parse_import(String.t()) :: map()
  def parse_import(input_file) do
    %{}
  end

  @doc "Orders upcoming anniversaries based on the run_date and returns a structured result"
  @spec order_data(map(), Date.t()) :: map()
  def order_data(data, run_date) do
    %{}
  end
end
