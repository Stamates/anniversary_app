defmodule AnniversaryApp.CurrentTimeMock do
  @moduledoc """
  Agent to mock current time functions by providing a set state if existing
  and falling back to the original mocked function usage if no state is set.
  """

  use Agent

  @doc "Starts an unsupervised Agent"
  @spec start(Date.t() | nil) :: {:ok, pid()} | {:error, {:already_started, pid()} | term()}
  def start(initial_value \\ nil) do
    Agent.start(fn -> initial_value end, name: __MODULE__)
  end

  @doc "Gets the state value from the Agent"
  @spec get :: Date.t()
  def get, do: Agent.get(__MODULE__, & &1)

  @doc "Sets the state value in the Agent"
  @spec update(Date.t()) :: :ok
  def update(%Date{} = value), do: Agent.update(__MODULE__, fn _ -> value end)

  @doc "Mocks Date.utc_today/0 function"
  @spec utc_today :: Date.t()
  def utc_today, do: get() || Date.utc_today()
end
