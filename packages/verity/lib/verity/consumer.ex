defmodule Verity.Consumer do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/consumers.html
  """

  defmacro __using__(opts) do
    handler = Keyword.fetch!(opts, :handlers)
    identifier = Keyword.get(opts, :identifier)

    quote location: :keep do
      import unquote(__MODULE__)

      def child_spec(opts) do
        identifier = unquote(identifier)
        handler = unquote(handler)

        consumer_child_spec(identifier, handler, opts)
      end
    end
  end

  def consumer_child_spec(identifier, handler, opts) do
    subscribed_to = Keyword.fetch!(opts, :stream_name)

    stream_name =
      if identifier do
        subscribed_to <> "+position-#{identifier}"
      else
        subscribed_to <> "+position"
      end

    MessageStore.ConsumerWorker.child_spec(
      config: %{
        stream_name: stream_name,
        subscribed_to: subscribed_to,
        handler: handler
      }
    )
  end
end
