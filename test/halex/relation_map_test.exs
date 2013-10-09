defmodule Halex.RelationMap.Test do
  use Halex.Case
  alias Halex.RelationMap
  alias Halex.Link

  test "create a new relation" do
    relations = RelationMap.new
    assert is_record(relations, RelationMap)
  end

  test "add item to reference map" do
    link = Link.new "/self"
    relations = RelationMap.new
    relations = relations.add :self, link
    assert [ self: lk_to_keys(link)] == relations.to_keywords
  end

  test "add suport a list of itens" do
    links = [Link.new("/adm/1"), Link.new("/adm/2")]
    relations = RelationMap.new(self: link = Link.new("/self"))
    relations = relations.add :adm, links
    assert [ adm: lk_to_keys(links), self: lk_to_keys(link) ] == relations.to_keywords
  end

  test "support add itens in create record" do
    [link | _] = links = [Link.new("/adm/1"), Link.new("/adm/2")]
    relations = RelationMap.new(adm: link)
    assert [ adm: lk_to_keys(link)] == relations.to_keywords

    relations = RelationMap.new(adm: links)
    assert [ adm: lk_to_keys(links)] == relations.to_keywords
  end

  test "define a relation method to get a itens" do
    relations = RelationMap.new(
      self: link = Link.new("/self"),
      adm: links = [Link.new("/adm/1"), Link.new("/adm/2")]
    )
    assert link  == relations.relation :self
    assert links == relations.relation :adm
  end

  test "support string in key" do
    link = Link.new "/self"
    relations = RelationMap.new([{"self", link}])
    assert [ self: lk_to_keys(link)] == relations.to_keywords
  end

  def lk_to_keys(links) when is_list(links) do
    lc link inlist links, do: link.to_keywords
  end

  def lk_to_keys(link) do
    link.to_keywords
  end
end
