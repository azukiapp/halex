ExUnit.start

defmodule Halex.Case do
  use ExUnit.CaseTemplate

  using _ do
    quote do
      import unquote(__MODULE__)
    end
  end

  # Helper to inspect values
  def pp(value), do: IO.inspect(value)
end
