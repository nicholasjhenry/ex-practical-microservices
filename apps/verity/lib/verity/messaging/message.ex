defmodule Verity.Messaging.Message do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/messages-and-message-data/messages.html
  """

  defmacro __using__(_opts) do
    quote do
      alias MessageStore.MessageData
      alias Messaging.Message.Metadata

      import unquote(__MODULE__)

      def build(metadata, attrs) do
        struct(__MODULE__, attrs) |> Map.put(:metadata, metadata)
      end

      def follow(message, attrs \\ %{}, meta \\ %{}) do
        fields = message |> Map.from_struct() |> Map.merge(attrs)
        new_message = struct!(__MODULE__, fields)
        %{new_message | metadata: Map.merge(message.metadata, meta)}
      end
    end
  end
end
