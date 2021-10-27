defmodule Verity.EntityProjection do
  @moduledoc """
  http://docs.eventide-project.org/user-guide/projection.html
  """

  @callback init() :: struct()
  @callback apply(struct(), map()) :: struct()

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour Verity.EntityProjection
    end
  end
end
