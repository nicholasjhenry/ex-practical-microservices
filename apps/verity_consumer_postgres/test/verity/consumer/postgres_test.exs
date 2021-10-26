defmodule Verity.Consumer.PostgresTest do
  use ExUnit.Case

  defmodule Dummy do
    use  Verity.Consumer.Postgres

    handler Foo
  end

  test "generates child spec with the specified handler and stream name" do
    expected_child_spec = %{
      id: :"bar+position",
      restart: :permanent,
      shutdown: 500,
      start: {MessageStore.ConsumerWorker, :start_link, [[config: %{handler: Foo, stream_name: "bar+position", subscribed_to: "bar"}]]},
      type: :worker
    }

    assert Dummy.child_spec(stream_name: "bar") == expected_child_spec
  end

  defmodule DummyWithIdentifier do
    use  Verity.Consumer.Postgres

    identifier :qux
    handler Foo
  end

  test "generates child spec with identifier" do
    expected_child_spec = %{
      id: :"bar+position-qux",
      restart: :permanent,
      shutdown: 500,
      start: {MessageStore.ConsumerWorker, :start_link, [[config: %{handler: Foo, stream_name: "bar+position-qux", subscribed_to: "bar"}]]},
      type: :worker
    }

    assert DummyWithIdentifier.child_spec(stream_name: "bar") == expected_child_spec
  end
end
