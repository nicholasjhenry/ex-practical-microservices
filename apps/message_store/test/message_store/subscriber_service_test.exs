
defmodule MessageStore.SubscriberServiceTest do
  use ExUnit.Case

  alias MessageStore.{Repo, SubscriberService}

  setup do
    Repo.truncate_messages()
    start_supervised!(MessageStore.Repo)

    :ok
  end

  describe "starting" do
    test "given no existing state" do
      {:ok, subscriber} = SubscriberService.start("subscriber-foo", "video")
      assert subscriber.current_position == -1
    end

    test "given existing state" do
      message = %{
        id: "5e731bdc-07aa-430a-8aae-543b45dd7235",
        stream_name: "subscriber-foo",
        type: "Read",
        data: %{position: 0},
        metadata: %{},
        expected_version: -1
      }

      MessageStore.write_message(message)

      {:ok, subscriber} = SubscriberService.start("subscriber-foo", "video")
      assert subscriber.current_position == 0
    end
  end
end
