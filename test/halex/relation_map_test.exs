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
    assert [ self: links_to_keywords(link)] == relations.to_keywords
  end

  test "add suport a list of itens" do
    links = [Link.new("/adm/1"), Link.new("/adm/2")]
    relations = RelationMap.new
    relations = relations.add :adm, links
    assert [ adm: links_to_keywords(links) ] == relations.to_keywords
  end

  test "support add itens in create record" do
    [link | _] = links = [Link.new("/adm/1"), Link.new("/adm/2")]
    relations = RelationMap.new(adm: link)
    assert [ adm: links_to_keywords(link)] == relations.to_keywords

    relations = RelationMap.new(adm: links)
    assert [ adm: links_to_keywords(links)] == relations.to_keywords
  end

  test "support string in key" do
    link = Link.new "/self"
    relations = RelationMap.new([{"self", link}])
    assert [ self: links_to_keywords(link)] == relations.to_keywords
  end

  def links_to_keywords(links) do
    lc link inlist List.wrap(links), do: link.to_keywords
  end
end
