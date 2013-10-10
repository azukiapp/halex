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
    assert 30.0  == order.property :total
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

  test "to_keywords with only links and properties" do
    order = Resource.new("/orders").property(:shippedToday, 20)
    hash  = [
      _links: [ self: order.link(:self).to_keywords ],
      _embedded: [],
      shippedToday: 20
    ]
    assert hash == order.to_keywords
  end

  test "to_keywords with links, properties and embedded" do
    order  = Resource.new("/orders/1").property(:status, "processing")
    orders = Resource.new("/orders").property(:shippedToday, 20)
    orders = orders.embed_resource :orders, order
    hash  = [
      _links: [ self: orders.link(:self).to_keywords ],
      _embedded: [orders: [[
        _links: [ self: order.link(:self).to_keywords ],
        _embedded: [],
        status: "processing"
      ]]],
      shippedToday: 20
    ]
    assert hash == orders.to_keywords
  end
end
