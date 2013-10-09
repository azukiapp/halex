defmodule Halex.Resource.Test do
  use Halex.Case
  alias Halex.Resource
  alias Halex.Resource.Link

  test "create a resource with self link" do
    order = Resource.new "/orders/123"
    assert Link.new(href: "/orders/123") == order.link :self
  end

  test "set and get properties" do
    order = Resource.new "/orders/123"
    order = order.property "total", 30.0
    assert 30.0 == order.property :total
    order = order.property :currency, "USD"
    assert "USD" == order.property "currency"
  end

  test "set and get links" do
    order = Resource.new "/orders/123"

    order = order.link "find", "/orders/{?id}", templated: true
    assert Link.new(href: "/orders/{?id}", templated: true) == order.link :find

    order = order.link :next, "/orders/3", name: "hotdog"
    assert Link.new(href: "/orders/3", name: "hotdog") == order.link "next"

    order = order.link :previus, "/orders/1"
    assert Link.new(href: "/orders/1") == order.link "previus"
  end
end
