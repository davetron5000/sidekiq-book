class OrderCreator

  CONFIRMATION_EMAIL_TEMPLATE_ID = "et_4928573945734895"

  # START:main-logic
  def create_order(order)
    if order.save
      payments_response = charge(order)
      if payments_response.success?

        email_response       = send_email(order)
        fulfillment_response = request_fulfillment(order)

        order.update!(
          charge_id: payments_response.charge_id,
          email_id: email_response.email_id,
          fulfillment_request_id: fulfillment_response.request_id)

        OrderSaved.new(order)
      else
        order.destroy!
        ChargeDeclined.new(order, payments_response.explanation)
      end
    else
      OrderInvalid.new(order)
    end
  end
  # END:main-logic

  class OrderResponse
    attr_reader :order
    def initialize(order)
      @order = order
    end
    def saved? = raise "subclass must implement"
    def reason_not_saved = nil
  end

  class OrderSaved < OrderResponse
    def saved? = true
  end

  class OrderInvalid < OrderResponse
    def saved? = false
  end
  class ChargeDeclined < OrderResponse
    attr_reader :reason_not_saved
    def initialize(order, reason_not_saved)
      super(order)
      @reason_not_saved = reason_not_saved
    end
    def saved? = false
  end

private

  def charge(order)
    payments.charge(
      order.user.payment_method_id,
      order.quantity * order.product.price_cents,
      { order: order.id }
    )
  end

  def send_email(order)
    email.send_email(
      order.email,
      CONFIRMATION_EMAIL_TEMPLATE_ID,
      { order_id: order.id }
    )
  end

  def request_fulfillment(order)
    fulfillment.request_fulfillment(
      order.user.id,
      order.address,
      order.product.id,
      order.quantity,
      { order: order.id }
    )
  end

  def payments    = PaymentsServiceWrapper.new
  def email       = EmailServiceWrapper.new
  def fulfillment = FulfillmentServiceWrapper.new
end
