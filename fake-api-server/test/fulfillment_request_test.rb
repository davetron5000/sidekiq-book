require "fake_api_server"
require "rack/test"
require "json"

class FulfillmentRequestTest < Minitest::Test
  include Rack::Test::Methods

  def app = Sinatra::Application

  def test_status
    get "/fulfillment/status", nil, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 200,last_response.status
  end

  def test_success
    request = {
      customer_id: 45,
      address: "123 any st",
      metadata: {
        order_id: 44,
      }
    }.to_json
    put "/fulfillment/request", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 202,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "accepted", response["status"]
    refute_nil response["request_id"]
  end

  def test_decline
    request = {
      customer_id: 45,
      address: nil,
      metadata: {
        order_id: 44,
      }
    }.to_json
    put "/fulfillment/request", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 422,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "rejected", response["status"]
    assert_equal "Missing address", response["error"]
    assert_nil response["request_id"]
  end
end
