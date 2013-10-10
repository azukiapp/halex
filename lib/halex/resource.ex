defmodule Halex.Resource do
  alias Halex.Link
  alias Halex.RelationMap

  defrecordp :record, __MODULE__, [
    properties: [],
    links: RelationMap.new,
    embedded: RelationMap.new.list!
  ]

  @type t :: __MODULE__
  @type property :: Atom.t | String.t
  @type relation :: Atom.t | String.t
  @type href     :: String.t

  @spec new(href) :: t
  def new(self) do
    record(links: RelationMap.new(self: Link.new(self)))
  end

  @spec property(property, t) :: any
  def property(name, record(properties: properties)) do
    dict_get(properties, name)
  end

  @spec property(property, any, t) :: t
  def property(name, value, record(properties: properties) = res) do
    record(res, properties: dict_put(properties, name, value))
  end

  @spec link(relation, t) :: Link.t
  def link(relation, record(links: links)) do
    links.relation(relation)
  end

  @spec embed(relation, t) :: [t]
  def embed(relation, record(embedded: embedded)) do
    embedded.relation(relation)
  end

  @spec add_link(relation, Link.t, t) :: t
  def add_link(relation, Link[] = link, record(links: links) = record) do
    record(record, links: links.add(relation, link))
  end

  @spec add_link(relation, href, Keyword.t, t) :: t
  def add_link(relation, href, opts // [], record() = record) do
    add_link(relation, Link.new(href, opts), record)
  end

  @spec embed_resource(relation, t | [t], t) :: t
  def embed_resource(relation, resources, record(embedded: embedded) = record) do
    record(record, embedded: embedded.add(relation, resources))
  end

  @spec to_keywords(t) :: Keyword.t
  def to_keywords(record(
    properties: properties, embedded: embedded, links: links)
  ) do
    Keyword.put(properties, :_embedded, embedded.to_keywords) |>
    Keyword.put(:_links, links.to_keywords)
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
