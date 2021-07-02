defmodule VideoTutorialsWeb.ConfigTest do
  use VideoTutorialsWeb.ConnCase, async: true

  alias VideoTutorialsWeb.Config

  def subject(_context), do: [subject: Config.get()]

  setup :subject

  describe "the application configuration" do
    test "includes the name", %{subject: subject} do
      assert subject.app_name == "Video Tutorials"
    end

    test "includes the env", %{subject: subject} do
      assert subject.env == :test
    end

    test "includes the port", %{subject: subject} do
      assert subject.port == 4002
    end

    test "includes the version", %{subject: subject} do
      assert subject.version == "0.1.0"
    end
  end
end
