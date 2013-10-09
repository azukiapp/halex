defmodule Halex.RelationMap do

  defrecordp :map, __MODULE__, relations: []

  @type t     :: __MODULE__
  @type key   :: Atom.t
  @type item  :: Halex.Link.t
  @type items :: [item] | item

  @spec new :: t
  def new, do: map()

  @spec new(Keyword.t) :: t
  def new(items) do
    Enum.reduce(items, map(), fn
      {key, values}, acc -> add(key, values, acc)
    end)
  end

  @spec add(key, items, t) :: t
  def add(relation, items, map(relations: relations) = map) do
    values = get(relations, relation) ++ List.wrap(items)
    map(map, relations: set(relations, relation, values))
  end

  @spec relation(key, t) :: item
  def relation(key, map(relations: relations)) do
    one_or_more(get(relations, key))
  end

  @spec to_keywords(t) :: Keyword.t
  def to_keywords(map(relations: relations)) do
    lc {key, items} inlist relations do
      {key, one_or_more(Enum.map(items, &(&1.to_keywords))) }
    end
  end

  defp one_or_more([item]), do: item
  defp one_or_more(items), do: items

  defp get(map, key, default // [])

  defp get(map, key, default) when is_bitstring(key) do
    get(map, :"#{key}", default)
  end

  defp get(map, key, default) do
    Keyword.get(map, key, default)
  end

  defp set(map, key, value) when is_bitstring(key) do
    set(map, :"#{key}", value)
  end

  defp set(map, key, value) do
    Keyword.put(map, key, value)
  end
end
