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
          charge_completed_at: Time.zone.now,
          charge_successful: true,
          email_id: email_response.email_id,
          fulfillment_request_id: fulfillment_response.request_id)
      else
        order.update!(
          charge_completed_at: Time.zone.now,
          charge_successful: false,
          charge_decline_reason: payments_response.explanation
        )
      end
    end
    order
  end
  # END:main-logic

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
