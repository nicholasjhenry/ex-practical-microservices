defmodule Verity.EntityStore do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/entity-store
  """

  defmacro __using__(opts) do
    category = Keyword.fetch!(opts, :category)
    _entity = Keyword.fetch!(opts, :entity)
    projection = Keyword.fetch!(opts, :projection)

    quote do
      import unquote(__MODULE__)
      import Verity.Messaging.StreamName

      def fetch(id) do
        stream_name = stream_name(id, unquote(category))
        MessageStore.fetch(stream_name, unquote(projection))
      end
    end
  end
end
