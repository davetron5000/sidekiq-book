class OrdersController < ApplicationController

  CONFIRMATION_EMAIL_TEMPLATE_ID = "et_4928573945734895"

  def new
    @order = Order.new
    setup_reference_data
  end
  def create
    @order = Order.new(order_params.merge(user: @current_user))
    if @order.save
      metadata = { order: @order.id }

      payments_response = payments.charge(
        @order.user.payment_method_id,
        @order.quantity * @order.product.price_cents,
        metadata)

      if payments_response.success?
        email_response = email.send_email(
          @order.email,
          CONFIRMATION_EMAIL_TEMPLATE_ID,
          metadata)

        fulfillment_response = fulfillment.request_fulfillment(
          @order.user.id,
          @order.address,
          @order.product.id,
          @order.quantity,
          metadata)

        @order.update!(
          charge_id: payments_response.charge_id,
          email_id: email_response.email_id,
          fulfillment_request_id: fulfillment_response.request_id)

        redirect_to order_path(@order)
      else
        @order.destroy!
        setup_reference_data
        flash[:alert] = "Payment declined: #{payments_response.explanation}"
        render :new
      end
    else
      setup_reference_data
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

private

  def setup_reference_data
    @products = Product.available
  end

  def order_params
    params.require(:order).permit(:product_id,
                                  :email,
                                  :address,
                                  :quantity)
  end

  def payments    = PaymentsServiceWrapper.new
  def email       = EmailServiceWrapper.new
  def fulfillment = FulfillmentServiceWrapper.new
end
