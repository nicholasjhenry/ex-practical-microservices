defmodule MessageStore.SubscriberTest do
  use ExUnit.Case

  alias MessageStore.Subscriber

  describe "starting a subscriber" do
    test "given no subscription message starts at the position 0" do
      subscription_message = nil
      subject = Subscriber.start(subscription_message)
      assert subject.position == 0
    end

    test "give a subscription message starts at the recorded position" do
      subscription_message = %{position: 10}
      subject = Subscriber.start(subscription_message)
      assert subject.position == 10
    end
  end
end
