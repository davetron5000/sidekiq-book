class PaymentsServiceWrapper < BaseServiceWrapper
  def initialize(delay_seconds=0)
    super("payments", ENV.fetch("PAYMENTS_API_URL"))
    @delay_seconds = delay_seconds.to_i
  end

  def emoji = Emoji.new(char: "💸",description: "Dollar bills with wings")

  def charge(customer_id, payment_method_id, amount_cents, metadata)
    uri = URI(@url + "/charge")
    body = {
      customer_id: customer_id,
      payment_method_id: payment_method_id,
      amount_cents: amount_cents,
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

  def clear!
    uri = URI(@url + "/charges")
    http_response = request(:delete, uri, "")
    if http_response.code != "200"
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

private

  def headers(content=nil)
    defaults = super(content)
    if @delay_seconds > 0
      defaults["X-Be-Slow"] = @delay_seconds.to_s
    end
    defaults
  end


end
