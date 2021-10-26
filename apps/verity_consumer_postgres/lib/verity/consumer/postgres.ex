defmodule Verity.Consumer.Postgres do
  defmacro __using__(_) do
    quote do
      @identifier nil
      import unquote(__MODULE__)
    end
  end

  defmacro identifier(id) do
    quote do
      @identifier unquote(id)
    end
  end

  defmacro handler(handler_module) do
    quote location: :keep do
      def child_spec(opts) do
        subscribed_to = Keyword.fetch!(opts, :stream_name)
        stream_name = if @identifier do
          subscribed_to <> "+position-#{@identifier}"
        else
          subscribed_to <> "+position"
        end

        MessageStore.ConsumerWorker.child_spec(
          config: %{
            stream_name: stream_name,
            subscribed_to: subscribed_to,
            handler: unquote(handler_module)
          }
        )
      end
    end
  end
end
