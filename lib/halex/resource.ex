defmodule Halex.Resource do

  defrecord Link, href: nil, templated: false, name: nil

  defrecordp :resource, __MODULE__, [
    self: nil,
    properties: [],
    links: []
  ]

  Record.import Link, as: :lk

  def new(self) do
    resource(self: self)
  end

  def property(name, resource(properties: properties) = res) do
    dict_get(properties, name)
  end

  def property(name, value, resource(properties: properties) = res) do
    resource(res, properties: dict_put(properties, name, value))
  end

  def link(:self, resource(self: self)) do
    lk(href: self)
  end

  def link(relation, href, opts // [], resource())

  def link(relation, href, opts, resource(links: links) = res) do
    opts = Dict.put(opts, :href, href)
    resource(res, links: dict_put(links, relation, Link.new(opts)))
  end

  def link(relation, resource() = res) when is_atom(relation) do
    link("#{relation}", res)
  end

  def link(relation, resource(links: links)) do
    dict_get(links, relation)
  end

  defp dict_put(dict, key, value) when is_atom(key) do
    dict_put(dict, "#{key}", value)
  end

  defp dict_put(dict, key, value) do
    Dict.put(dict, key, value)
  end

  defp dict_get(dict, key) when is_atom(key) do
    dict_get(dict, "#{key}")
  end

  defp dict_get(dict, key) do
    Dict.get(dict, key)
  end
end
