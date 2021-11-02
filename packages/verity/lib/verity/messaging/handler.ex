defmodule Verity.Messaging.Handler do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/handlers.html
  """

  defmacro defhandle({:__aliases__, _meta, [message_module]} = message_alias, caller_context,
             do: block
           ) do
    message_type = to_string(message_module)

    # Extract the message var, e.g. %{message: my_message} => my_message
    {:%{}, _, [message: message_var]} = caller_context

    # Transform the 'context' to a pattern matching context,
    # e.g. %{message: my_message} => %{type: "MyCommand"} = my_message
    runtime_context =
      quote location: :keep do
        %{type: unquote(message_type)} = unquote(message_var)
      end

    # Ensure the AST is expanded together with Macro.escape/2, bind_quoted option and unquote/1
    # combination to avoid variable scoping errors, e.g:
    #
    # variable "foo" does not exist and is being expanded to "foo()", please use parentheses to
    # remove the ambiguity or change the variable name
    #
    block = Macro.escape(block)
    message_alias = Macro.escape(message_alias)
    message_var = Macro.escape(message_var)
    runtime_context = Macro.escape(runtime_context)

    quote location: :keep,
          bind_quoted: [
            block: block,
            message_alias: message_alias,
            message_var: message_var,
            runtime_context: runtime_context
          ] do
      def handle_message(unquote(runtime_context)) do
        # Transform the MessageData.Read to the applications message, e.g.
        # my_message = MyCommand.parse(my_message)
        unquote(message_var) = apply(unquote(message_alias), :parse, [unquote(message_var)])
        # Handler Code
        unquote(block)
      end
    end
  end

  defmacro __using__(_opts) do
    quote location: :keep do
      import unquote(__MODULE__)
      import Verity.Messaging.StreamName
      import Verity.Messaging.Write
    end
  end
end
