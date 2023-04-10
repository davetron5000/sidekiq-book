class OrderCreator

  CONFIRMATION_EMAIL_TEMPLATE_ID = "et_4928573945734895"

  def initialize(payments_service_wrapper: :use_default,
                 email_service_wrapper: :use_default,
                 fulfillment_service_wrapper: :use_default)
    @payments_service_wrapper = if payments_service_wrapper == :use_default
                                  PaymentsServiceWrapper.new
                                else
                                  payments_service_wrapper
                                end
    @email_service_wrapper = if email_service_wrapper == :use_default
                               EmailServiceWrapper.new
                             else
                               email_service_wrapper
                             end

    @fulfillment_service_wrapper = if fulfillment_service_wrapper == :use_default
                                           FulfillmentServiceWrapper.new
                                         else
                                           fulfillment_service_wrapper
                                         end
  end

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
    charge_metadata = {
      order_id: order.id,
      idempotency_key: "idempotency_key-#{order.id}",
    }
    payments.charge(
      order.user.payment_method_id,
      order.quantity * order.product.price_cents,
      charge_metadata
    )
  end

  def send_email(order)
    email_metadata = { order_id: order.id }
    email.send_email(
      order.email,
      CONFIRMATION_EMAIL_TEMPLATE_ID,
      email_metadata
    )
  end

  def request_fulfillment(order)
    fulfillment_metadata = { order_id: order.id }
    fulfillment.request_fulfillment(
      order.user.id,
      order.address,
      order.product.id,
      order.quantity,
      fulfillment_metadata
    )
  end

  def payments    = @payments_service_wrapper
  def email       = @email_service_wrapper
  def fulfillment = @fulfillment_service_wrapper
end
