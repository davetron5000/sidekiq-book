class FulfillmentServiceWrapper < BaseServiceWrapper
  def initialize
    super("order fulfillment", ENV.fetch("FULLFILLMENT_API_URL"))
  end
  def request_fulfillment(customer_id, address, product_id, quantity, metadata)
    uri = URI(@url + "/request")
    body = {
      customer_id: customer_id,
      address: address,
      product_id: product_id,
      quantity: quantity,
      metadata: metadata,
    }
    http_response = request(:put, uri, body)
    if http_response.code == "202"
      response = JSON.parse(http_response.body)
      Success.new(response["request_id"])
    else
      raise_error!(http_response)
    end
  end

private

  class Success
    attr_reader :request_id
    def initialize(request_id)
      @request_id = request_id
    end
    def success? = true
  end
end
