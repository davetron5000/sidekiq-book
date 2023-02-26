require "fake_api_server"
require "rack/test"
require "json"

class CreditCardTest < Minitest::Test
  include Rack::Test::Methods

  def app = Sinatra::Application

  def test_status
    get "/payments/status", nil, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 200,last_response.status
  end

  def test_success
    request = {
      customer_id: 88,
      payment_method_id: 99,
      amount_cents: 65_10,
      metadata: {
        order_id: 44,
      }
    }.to_json
    post "/payments/charge", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 201,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "success", response["status"]
    refute_nil response["charge_id"]
  end

  def test_de_dupe
    request = {
      customer_id: 45,
      payment_method_id: 99,
      amount_cents: 65_10,
      metadata: {
        order_id: 44,
      }
    }.to_json
    post "/payments/charge", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 201,last_response.status

    post "/payments/charge", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 200,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "declined", response["status"]
    assert_equal "Possible fraud", response["explanation"]
    assert_nil response["charge_id"]
  end

  def test_decline
    request = {
      customer_id: 33,
      payment_method_id: 99,
      amount_cents: 99_99, # magic amount
      metadata: {
        order_id: 44,
      }
    }.to_json
    post "/payments/charge", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 200,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "declined", response["status"]
    assert_equal "Insufficient funds", response["explanation"]
    assert_nil response["charge_id"]
  end

  def test_nonsense
    post "/payments/charge", "foo bar blah: ", { "HTTP_ACCEPT" => "application/json" }
    assert_equal 422,last_response.status
  end
end
