defmodule Verity.Client do
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :__deps__, accumulate: true)
      @before_compile unquote(__MODULE__)

      import unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def __deps__ do
        @__deps__
      end
    end
  end

  defmacro export(module, as: alias_name) do
    quote do
      @__deps__ {unquote(alias_name), unquote(module)}
    end
  end

  defmacro include(module, alias: alias_name) do
    {module, []} = Code.eval_quoted(module)
    {alias_name, []} = Code.eval_quoted(alias_name)
    deps = module.__deps__()
    dep = Keyword.fetch!(deps, alias_name)

    quote do
      alias unquote(dep)
    end
  end
end
