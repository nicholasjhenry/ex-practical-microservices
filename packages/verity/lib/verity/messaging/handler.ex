defmodule Verity.Messaging.Handler do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/handlers.html
  """

  defmacro def({:handle_message, head_metadata, [{:=, _, _} = message_match]}, do: body) do
    {:=, _,
     [
       {:%, _, [{:__aliases__, _, [message_module]} = message_alias, {:%{}, _, _}]},
       message_var
     ]} = message_match

    message_type = to_string(message_module)

    message_data_match =
      quote location: :keep do
        %{type: unquote(message_type)} = message_data
      end

    head = {:handle_message, head_metadata, [message_data_match]}

    quote location: :keep do
      Kernel.def unquote(head) do
        unquote(message_var) = apply(unquote(message_alias), :parse, [message_data])
        unquote(body)
      end
    end
  end

  defmacro def(head, do: body) do
    quote do
      Kernel.def unquote(head) do
        unquote(body)
      end
    end
  end

  defmacro __using__(_opts) do
    quote location: :keep do
      import unquote(__MODULE__)
      import Verity.Messaging.StreamName
      import Verity.Messaging.Write
      import Kernel, except: [def: 2]
    end
  end
end
