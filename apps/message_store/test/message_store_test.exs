defmodule MessageStoreTest do
  use ExUnit.Case
  doctest MessageStore

  test "greets the world" do
    assert MessageStore.hello() == :world
  end
end
