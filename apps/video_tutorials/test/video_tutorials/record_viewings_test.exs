defmodule VideoTutorials.RecordViewingsTest do
  use ExUnit.Case, async: false

  alias VideoTutorials.RecordViewings

  setup do
    MessageStore.Repo.truncate_messages()

    :ok
  end

  describe "record_viewing" do
    test "writes the messages" do
      subject = &RecordViewings.record_viewing/3

      assert :ok = subject.(1, 1, 1)
    end
  end
end
