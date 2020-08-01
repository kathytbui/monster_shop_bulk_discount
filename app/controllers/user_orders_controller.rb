class UserOrdersController < ApplicationController

  def index
    @user = user
  end

  def show
    @order = Order.find(params[:order_id])
  end

end
