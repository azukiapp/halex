defmodule Halex.Resource.Test do
  use Halex.Case
  alias Halex.Resource
  alias Halex.Link

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

  test "creates a link then maps" do
    order = Resource.new "/orders/123"

    order = order.add_link "find", "/orders/{?id}", templated: true
    assert Link.new("/orders/{?id}", templated: true) == order.link :find

    order = order.add_link :next, "/orders/3", name: "hotdog"
    assert Link.new("/orders/3", name: "hotdog") == order.link "next"

    order = order.add_link :previus, "/orders/1"
    assert Link.new("/orders/1") == order.link "previus"
  end

  test "maps the link to relation" do
    order = Resource.new "/orders/123"
    order = order.add_link :next, link = Link.new("/orders/1")
    assert link == order.link :next
  end

  test "support to embed resources" do
    order  = Resource.new "/orders/123"
    order  = order.add_link :customer, "/customers/7809"

    orders = Resource.new "/orders"
    orders = orders.embed_resource :orders, order

    assert [order] == orders.embed "orders"
  end
end
