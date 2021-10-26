defmodule Verity.Consumer.Postgres do
  defmacro handler(handler_module) do
    quote do
      def child_spec(opts) do
        stream_name = Keyword.fetch!(opts, :stream_name)

        MessageStore.ConsumerWorker.child_spec(
          config: %{
            stream_name: stream_name <> "+position",
            subscribed_to: stream_name,
            handler: unquote(handler_module)
          }
        )
      end
    end
  end
end
