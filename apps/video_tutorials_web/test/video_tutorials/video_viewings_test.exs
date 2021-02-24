defmodule VideoTutorials.VideoViewingsTest do
  use VideoTutorials.DataCase

  alias VideoTutorials.VideoViewings

  describe "record_viewing" do
    test "writes the messages" do
      subject = &VideoViewings.record_viewing/3

      assert :ok = subject.(1, 1, 1)
    end

    test "handles multiple writes" do
      subject = &VideoViewings.record_viewing/3

      assert :ok = subject.(1, 1, 1)
      assert :ok = subject.(1, 1, 1)
    end
  end
end
