class PaymentsServiceWrapper < BaseServiceWrapper
  def initialize
    super("payments", ENV.fetch("PAYMENTS_API_URL"))
  end

  def charge(payment_method_id, amount_cents, metadata)
    uri = URI(@url + "/charge")
    body = {
      amount_cents: amount_cents,
      payment_method_id: payment_method_id,
      metadata: metadata,
    }
    http_response = request(:post,uri,body)
    if http_response.code == "201"
      response = JSON.parse(http_response.body)
      Success.new(response["charge_id"])
    elsif http_response.code == "200"
      response = JSON.parse(http_response.body)
      Decline.new(response["explanation"])
    else
      raise_error!(http_response)
    end
  end

  class Success
    attr_reader :charge_id
    def initialize(charge_id)
      @charge_id = charge_id
    end
    def success? = true
  end

  class Decline
    attr_reader :explanation
    def initialize(explanation)
      @explanation = explanation
    end
    def success? = false
  end

end
