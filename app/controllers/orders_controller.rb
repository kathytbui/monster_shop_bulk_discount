class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = "Order successfully placed"
      redirect_by_role(order)
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:order_id])
    if order.item_orders.all? {|i_o| i_o. status == 'fulfilled'}
      order.update(status: 1)
    end
    redirect_to "/profile/orders/#{order.id}"
  end

  def destroy
    order = Order.find(params[:id])
    # return any fulfilled items to merchants
    order.status = 4
    order.cancel_item_orders
    order.save
    flash[:success] = "Your order is cancelled"
    redirect_by_role(order)
  end

  private

  def redirect_by_role(order)
    if user.default?
      redirect_to '/profile/orders'
    else
      redirect_to "/orders/#{order.id}"
    end
  end

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

end
