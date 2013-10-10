defmodule Halex.Link do

  # Record fields and default values
  @fields [
    href: nil, templated: true, type: nil,
    deprecation: nil, name: nil, profile: nil,
    title: nil, hreflang: nil
  ]

  # Record def
  Record.deffunctions(@fields, __ENV__)
  Record.import __MODULE__, as: :link

  @type t :: __MODULE__
  @type href :: String.t

  @spec new(href, Keyword.t) :: t
  def new(href, opts // []) when is_bitstring(href) do
    Keyword.merge([href: href], opts) |> new
  end
end
