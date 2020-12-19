
defmodule MessageStore.SubscriberServiceTest do
  use ExUnit.Case

  alias MessageStore.SubscriberService

  describe "starting" do
    test "given no existing state" do
      {:ok, subscriber} = SubscriberService.start("video")
      assert subscriber.current_position == -1
    end
  end
end
