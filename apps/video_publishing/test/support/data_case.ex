defmodule VideoPublishing.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import VideoPublishing.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(VideoTutorials.Repo)

    MessageStore.Repo.truncate_messages()

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(VideoTutorials.Repo, {:shared, self()})
    end

    :ok
  end
end
