class CartController < ApplicationController
  before_action :deny_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def update_item
    item = Item.find(params[:item_id])
    quantity = params[:quantity].to_i
    if quantity > item.inventory
      flash[:error] = "Quantity cannot be greater than #{item.inventory}"
      redirect_to '/cart'
    elsif quantity < 0
      flash[:error] = "Quantity cannot be less than 0"
      redirect_to '/cart'
    elsif quantity == 0
      remove_item
    else
      cart.contents[params[:item_id]] = quantity
      redirect_to '/cart'
    end
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  private
  def deny_admin
    if !user.nil? && user.admin?
      render file: "/public/404"
    end
  end
end
