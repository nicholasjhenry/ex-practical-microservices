defmodule VideoTutorials.HomePageTest do
  use VideoTutorials.DataCase

  alias MessageStore.MessageData
  alias VideoTutorials.HomePage
  alias VideoTutorialsData.Page

  setup do
    Repo.insert!(%Page{name: "home", data: %{"videos_watched" => 5, "last_view_processed" => 10}})
    HomePage.subscribe()

    :ok
  end

  describe "handling watched events" do
    test "given the page exists the counter" do
      event =
        MessageData.Read.new(
          id: UUID.uuid4(),
          stream_name: "video-1",
          type: "videoWatched",
          data: %{},
          metadata: %{},
          position: 0,
          global_position: 11,
          time: NaiveDateTime.local_now()
        )

      HomePage.handle_message(event)

      page = Repo.get_by!(Page, name: "home")
      assert page.data["videos_watched"] == 6
      assert page.data["last_view_processed"] == 11
      assert_receive :home_page_updated
    end

    test "given the event had been previously processed the counter is not incremented" do
      event =
        MessageData.Read.new(
          id: UUID.uuid4(),
          stream_name: "video-1",
          type: "videoWatched",
          data: %{},
          metadata: %{},
          position: 0,
          global_position: 10,
          time: NaiveDateTime.local_now()
        )

      HomePage.handle_message(event)

      page = Repo.get_by!(Page, name: "home")
      assert page.data["videos_watched"] == 5
      assert page.data["last_view_processed"] == 10
      refute_receive :home_page_updated
    end
  end

  describe "loading home page" do
    test "returns the home page" do
      page = HomePage.load_home_page()

      assert page.name == "home"
    end
  end
end
