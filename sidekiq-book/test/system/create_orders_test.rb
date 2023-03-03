require "application_system_test_case"

class CreateOrdersTest < ApplicationSystemTestCase
  test "creating an order" do
    user = User.find_or_initialize_by(email: "pat@example.com")
    user.update!(payment_method_id: SecureRandom.uuid)

    one = Product.find_or_initialize_by(name: "Flux Capacitor")
    one.update!(price_cents: rand(100_00) + 1_00,
                quantity_remaining: rand(100) + 1)

    two = Product.find_or_initialize_by(name: "Pulse Width Generator")
    two.update!(price_cents: rand(100_00) + 1_00,
                quantity_remaining: rand(100) + 1)

    not_available = Product.find_or_initialize_by(name: "Thrombic Modulator")
    not_available.update!(price_cents: rand(100_00) + 1_00,
                          quantity_remaining: 0)

    visit new_order_url
    refute page.has_select?("order[product_id]", with_options: [ not_available.name ]),
      "Product '#{not_available.name}' has a quantity of 0, yet was in the select list of options"

    click_on "Place Order"

    assert_selector "aside[data-error]", text: /Can't create the order/
    assert_selector "aside[data-error]", text: /Product must exist/
    assert_selector "aside[data-error]", text: /Email can't be blank/
    assert_selector "aside[data-error]", text: /Address can't be blank/
    refute_selector "aside[data-error]", text: /User must exist/

    select one.name
    fill_in "order[email]", with: "pat@example.com"
    fill_in "order[address]", with: "123 any st\nspringfield, va 90210"
    fill_in "order[quantity]", with: 2

    click_on "Place Order"

    refute_selector "aside[data-error]"
    order = Order.last
    assert_selector "h1", text: "Order #{order.id}"

    assert_equal one                                  , order.product
    assert_equal 2                                    , order.quantity
    assert_equal "pat@example.com"                    , order.email
    assert_equal "123 any st\r\nspringfield, va 90210", order.address
    assert_equal user                                 , order.user
    refute_nil   order.charge_id
    refute_nil   order.email_id
    refute_nil   order.fulfillment_request_id
  end

  test "credit card decline" do
    user = User.find_or_initialize_by(email: "pat@example.com")
    user.update!(payment_method_id: SecureRandom.uuid)

    amount_that_forces_decline = 99_99
    one = Product.find_or_initialize_by(name: "Flux Capacitor")
    one.update!(price_cents: amount_that_forces_decline,
                quantity_remaining: 1)

    two = Product.find_or_initialize_by(name: "Pulse Width Generator")
    two.update!(price_cents: rand(100_00) + 1_00,
                quantity_remaining: rand(100) + 1)

    not_available = Product.find_or_initialize_by(name: "Thrombic Modulator")
    not_available.update!(price_cents: rand(100_00) + 1_00,
                          quantity_remaining: 0)

    visit new_order_url

    select one.name
    fill_in "order[email]", with: "pat@example.com"
    fill_in "order[address]", with: "123 any st\nspringfield, va 90210"
    fill_in "order[quantity]", with: 1

    click_on "Place Order"

    assert_selector "aside[data-error]", text: /Payment declined: Insufficient funds/i
    order = Order.last
    assert_nil order
  end
end
