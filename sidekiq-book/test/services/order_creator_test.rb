require "test_helper"

class OrderCreatorTest < ActiveSupport::TestCase
  setup do
    @order_creator = OrderCreator.new
  end

  test "create_order charge declines" do
    product = Product.create!(
      name: "Test Product",
      price_cents: 99_99, # special value that triggers a decline
      quantity_remaining: 10
    )
    user = User.create!(
      email: "pat@example.com",
      payment_method_id: SecureRandom.uuid,
    )
    order = Order.create!(
      email: "pat@example.com",
      address: "123 Main St",
      quantity: 1,
      product: product,
      user: user,
    )
    resulting_order = @order_creator.create_order(order)
    assert_equal order, resulting_order
    refute resulting_order.charge_successful
    assert_equal "Insufficient funds", resulting_order.charge_decline_reason
    assert_nil resulting_order.charge_id
  end

  test "create_order charge succeeds" do
    product = Product.create!(
      name: "Test Product",
      price_cents: 100,
      quantity_remaining: 10
    )
    user = User.create!(
      email: "pat@example.com",
      payment_method_id: SecureRandom.uuid,
    )
    order = Order.create!(
      email: "pat@example.com",
      address: "123 Main St",
      quantity: 2,
      product: product,
      user: user,
    )

    resulting_order = @order_creator.create_order(order)
    assert_equal order, resulting_order
    assert resulting_order.charge_successful
    assert_nil resulting_order.charge_decline_reason
    refute_nil resulting_order.charge_id
    refute_nil resulting_order.email_id
    refute_nil resulting_order.fulfillment_request_id
  end

end
