require "fake_api_server"
require "rack/test"
require "json"

class EmailTest < Minitest::Test
  include Rack::Test::Methods

  def app = Sinatra::Application

  def test_status
    get "/email/status", nil, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 200,last_response.status
  end

  def test_success
    request = {
      to: "pat@example.com",
      template_id: "12345",
      template_data: {
        name: "Pat",
        order_id: 44,
      }
    }.to_json
    post "/email/send", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 202,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "queued", response["status"]
    refute_nil response["email_id"]
  end

  def test_missing_template_id
    request = {
      to: "pat@example.com",
      template_data: {
        name: "Pat",
        order_id: 44,
      }
    }.to_json
    post "/email/send", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 422,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "not-queued", response["status"]
    assert_equal "template_id required", response["errorMessage"]
    assert_nil response["email_id"]
  end

  def test_missing_to
    request = {
      template_id: "1234",
      template_data: {
        name: "Pat",
        order_id: 44,
      }
    }.to_json
    post "/email/send", request, { "HTTP_ACCEPT" => "application/json" }
    assert_equal 422,last_response.status
    response = JSON.parse(last_response.body)
    assert_equal "not-queued", response["status"]
    assert_equal "to required", response["errorMessage"]
    assert_nil response["email_id"]
  end

end
