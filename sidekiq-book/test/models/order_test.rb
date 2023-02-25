require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "quantity that exceeds availability is invalid" do
    one = Product.find_or_initialize_by(name: "Flux Capacitor")
    one.update!(price_cents: rand(100_00) + 1_00,
                quantity_remaining: 10)

    order = Order.new(email: "pat@example.com",
                      address: "123 any st",
                      product: one,
                      quantity: 11)

    assert order.invalid?,"Order should've been invalid"
    assert_includes order.errors,:quantity
    assert_includes order.errors[:quantity],"is more than what is in stock"

    order.quantity = 10
    assert order.valid?,"Order should've been valid: #{order.errors.inspect}"

  end
end
