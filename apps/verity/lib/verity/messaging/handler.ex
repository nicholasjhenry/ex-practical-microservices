defmodule Verity.Messaging.Handler do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/handlers.html
  """

  @callback handle_message(map()) :: any()

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour Verity.Messaging.Handler

      import Verity.Messaging.StreamName
      import Verity.Messaging.Write
    end
  end
end
