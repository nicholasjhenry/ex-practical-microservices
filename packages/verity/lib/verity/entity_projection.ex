defmodule Verity.EntityProjection do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/projection.html
  """

  @callback init() :: struct()
  @callback apply(struct(), map()) :: struct()

  defmacro def({:apply, head_metadata, [entity_var, message_match]}, do: body) do
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

    head = {:apply, head_metadata, [entity_var, message_data_match]}

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
      @behaviour Verity.EntityProjection

      import unquote(__MODULE__)
      import Kernel, except: [def: 2]
    end
  end
end
