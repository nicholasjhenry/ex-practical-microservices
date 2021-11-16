defmodule Verity.Messaging.Handler do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/handlers.html
  """

  @doc """
  Rewrite the `handle/1` function to match on the message struct provided.

  ## Example

      def handle_message(%MyMessage{} = message)

  is rewritten to:

      def handle_message(%{type: "MyMessage"} = message_data)

  This matches on the MessageData, parses it to the message struct provided in the macro. This simplistic
  approach removes the need for a message registry for now.

  """
  # Pattern match on `def handle_message(%MyMessage{} = message)`
  defmacro def(
             {:handle_message, head_metadata, [{:=, _, _} = message_match]} =
               message_struct_function_head,
             do: body
           ) do
    # From the message_match, e.g. `%MyMessage{}` = message, extract:
    # 1. message_module `MyMessage`
    # 2. message_alias: the alias reference for the message struct `MyMessage`

    {:=, _,
     [
       {:%, _, [{:__aliases__, _, [message_module]} = message_alias, {:%{}, _, _}]},
       _message_var
     ]} = message_match

    # Convert the message module to the message type persisted in the message store, e.g.
    #   MyMessage => "MyMessage"
    message_type = to_string(message_module)

    # Create a new parameter based on the message data e.g.
    #   %{type: "MyMessage"} = message_data
    message_data_match =
      quote location: :keep do
        %{type: unquote(message_type)} = message_data
      end

    # Create a new function head e.g.
    #   def handle_message(%{type: "MyMessage"} = message_data)
    message_data_function_head = {:handle_message, head_metadata, [message_data_match]}

    quote location: :keep do
      # Pattern matching function head for message data
      Kernel.def unquote(message_data_function_head) do
        # Parse the message data into a message struct e.g.
        #   %MessageData.Read{type: 'MyMessage'} => %MyMessage{}
        message_struct = apply(unquote(message_alias), :parse, [message_data])
        # Call the original definition
        handle_message(message_struct)
      end

      # The original function definition
      Kernel.def unquote(message_struct_function_head) do
        unquote(body)
      end
    end
  end

  # A pass through macro for all other function definitions
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
