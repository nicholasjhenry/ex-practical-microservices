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

      def to_message_data(command) do
        data_keys = Map.keys(command) -- [:__struct__, :metadata]

        data =
          data_keys
          |> Enum.map(fn key -> {Recase.to_camel(key), Map.fetch!(command, key)} end)
          |> Map.new()

        type = __MODULE__ |> to_string |> String.split(".") |> List.last()

        MessageData.Write.new(
          stream_name: nil,
          type: type,
          metadata: Metadata.to_raw(command.metadata),
          data: data,
          expected_version: nil
        )
      end
    end
  end
end
