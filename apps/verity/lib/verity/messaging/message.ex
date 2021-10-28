defmodule Verity.Messaging.Message do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/messages-and-message-data/messages.html
  """

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end
end
