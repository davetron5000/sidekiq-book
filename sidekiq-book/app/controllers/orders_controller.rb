class OrdersController < ApplicationController
  def new
    @order = Order.new
    setup_reference_data
  end
  def create
    @order = Order.create(order_params)
    if @order.valid?
      redirect_to order_path(@order)
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
end
