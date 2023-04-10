require "test_helper"

class OrderCreatorTest < ActiveSupport::TestCase
  setup do
    @mock_payments_service_wrapper = Minitest::Mock.new
    @mock_email_service_wrapper = Minitest::Mock.new
    @mock_fulfillment_service_wrapper = Minitest::Mock.new

    @mock_payments_service_wrapper.expect(:==, false, [ :use_default ])
    @mock_email_service_wrapper.expect(:==, false, [ :use_default ])
    @mock_fulfillment_service_wrapper.expect(:==, false, [ :use_default ])

    @order_creator = OrderCreator.new(
      payments_service_wrapper: @mock_payments_service_wrapper,
      email_service_wrapper: @mock_email_service_wrapper,
      fulfillment_service_wrapper: @mock_fulfillment_service_wrapper)
  end

  test "create_order charge declines" do
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
    @mock_payments_service_wrapper.expect(
      :charge,
      OpenStruct.new(success?: false, explanation: "Some failure"),
      [user.payment_method_id, 200, { order_id: order.id }])
    resulting_order = @order_creator.create_order(order)
    assert_equal order, resulting_order
    refute resulting_order.charge_successful
    assert_equal "Some failure", resulting_order.charge_decline_reason
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
    charge_id = SecureRandom.uuid
    email_id = SecureRandom.uuid
    request_id = SecureRandom.uuid
    @mock_payments_service_wrapper.expect(
      :charge,
      OpenStruct.new(success?: true, charge_id: charge_id),
      [user.payment_method_id, 200, { order_id: order.id }])
    @mock_email_service_wrapper.expect(
      :send_email,
      OpenStruct.new(email_id: email_id),
      [order.email, OrderCreator::CONFIRMATION_EMAIL_TEMPLATE_ID, { order_id: order.id }])
    @mock_fulfillment_service_wrapper.expect(
      :request_fulfillment,
      OpenStruct.new(request_id: request_id),
      [order.user.id, order.address, order.product.id, order.quantity, { order_id: order.id }])

    resulting_order = @order_creator.create_order(order)
    assert_equal order, resulting_order
    assert resulting_order.charge_successful
    assert_nil resulting_order.charge_decline_reason
    assert_equal charge_id, resulting_order.charge_id
    assert_equal email_id, resulting_order.email_id
    assert_equal request_id, resulting_order.fulfillment_request_id
  end

end
