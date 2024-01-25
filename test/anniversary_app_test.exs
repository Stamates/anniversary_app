defmodule AnniversaryAppTest do
  use ExUnit.Case
  doctest AnniversaryApp

  test "greets the world" do
    assert AnniversaryApp.hello() == :world
  end
end
