defmodule AnniversaryApp.CurrentTime do
  @moduledoc """
  This module provides and adapter and functions to be able to switch out
  current time functions during testing.
  """

  @doc "Gets the module to be used in current time functions"
  @spec adapter :: atom()
  def adapter, do: Application.get_env(:anniversary_app, :time_module, Date)

  @doc "Gets the current utc date"
  @spec utc_today :: Date.t()
  def utc_today, do: adapter().utc_today()
end
