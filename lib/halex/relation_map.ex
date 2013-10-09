defmodule Halex.RelationMap do

  defrecordp :map, __MODULE__, relations: []

  @type t     :: __MODULE__
  @type key   :: Atom.t
  @type item  :: Halex.Link.t
  @type itens :: [item] | item

  @spec new :: t
  def new, do: map()

  @spec new(Keyword.t) :: t
  def new(itens) do
    Enum.reduce(itens, map(), fn
      {key, values}, acc -> add(key, values, acc)
    end)
  end

  @spec add(key, itens, t) :: t
  def add(relation, itens, map(relations: relations) = map) do
    values = get(relations, relation) ++ List.wrap(itens)
    map(relations: set(relations, relation, values))
  end

  def to_keywords(map(relations: relations)) do
    lc {key, items} inlist relations do
      {key, Enum.map(items, &(&1.to_keywords))}
    end
  end

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
