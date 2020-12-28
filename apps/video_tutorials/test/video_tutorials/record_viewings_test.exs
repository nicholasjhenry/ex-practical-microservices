defmodule VideoTutorials.RecordViewingsTest do
  use ExUnit.Case

  alias VideoTutorials.RecordViewings

  describe "record_viewing" do
    test "writes the messages" do
      subject = &RecordViewings.record_viewing/3

      assert :ok = subject.(1, 1, 1)
    end
  end
end
