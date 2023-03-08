class OrdersController < ApplicationController

  def new
    @order = Order.new
    setup_reference_data
  end
  def create
    result = OrderCreator.new.create_order(
      Order.new(order_params.merge(user: @current_user))
    )

    if result.saved?
      redirect_to order_path(result.order)
      return
    end

    @order = result.order

    if @order.invalid?
      setup_reference_data
      render :new
      return
    end

    setup_reference_data
    flash[:alert] = "Payment declined: #{result.reason_not_saved}"
    render :new

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
end
