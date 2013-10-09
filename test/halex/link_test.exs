defmodule Halex.Link.Test do
  use Halex.Case
  alias Halex.Link

  test "create a link by href url" do
    link = Link.new("/example")
    assert is_record(link, Link)
    assert "/example" == link.href
  end

  test "create a link by href and options" do
    link = Link.new("/example", name: "name")
    assert "/example" == link.href
    assert "name" == link.name
  end
end
