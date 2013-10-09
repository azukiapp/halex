defmodule Halex.Resource do
  alias Halex.Link
  alias Halex.RelationMap

  defrecordp :resource, __MODULE__, [
    properties: [],
    links: RelationMap.new
  ]

  @type t :: __MODULE__
  @type property :: Atom.t | String.t
  @type href     :: String.t

  @spec new(href) :: t
  def new(self) do
    resource(links: RelationMap.new(self: Link.new(self)))
  end

  def property(name, resource(properties: properties)) do
    dict_get(properties, name)
  end

  def property(name, value, resource(properties: properties) = res) do
    resource(res, properties: dict_put(properties, name, value))
  end

  def link(relation, resource(links: links)) do
    links.relation(relation)
  end

  def add_link(relation, Link[] = link, resource(links: links) = resource) do
    resource(resource, links: links.add(relation, link))
  end

  def add_link(relation, href, opts // [], resource() = resource) do
    add_link(relation, Link.new(href, opts), resource)
  end

  defp dict_put(dict, key, value) when is_bitstring(key) do
    dict_put(dict, :"#{key}", value)
  end

  defp dict_put(dict, key, value) do
    Dict.put(dict, key, value)
  end

  defp dict_get(dict, key) when is_bitstring(key) do
    dict_get(dict, :"#{key}")
  end

  defp dict_get(dict, key) do
    Dict.get(dict, key)
  end
end
