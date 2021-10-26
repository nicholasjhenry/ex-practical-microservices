defmodule VerityConsumerPostgresTest do
  use ExUnit.Case
  doctest VerityConsumerPostgres

  test "greets the world" do
    assert VerityConsumerPostgres.hello() == :world
  end
end
