class Merchant::ItemsController < Merchant::BaseController

  def index
    @items = user.merchant.items
  end

  def new
    @user_input ||= Hash.new("")
  end

  def show
    @item = Item.find(params[:item_id])
  end

  def destroy
    item = Item.find(params[:item_id])
    if item.no_orders?
      item.delete
      flash[:success] = "Item has been deleted"
    else
      flash[:error] = "Item has been ordered before and cannot be deleted"
    end
    redirect_to "/merchant/items"
  end

  def create
    item = user.merchant.items.create(item_params)
    if item.save
      flash[:success] = "Item has been saved"
      redirect_to "/merchant/items"
    else
      @user_input = item_params
      flash[:errors] = item.errors.full_messages
      render :new
    end
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def update
    item = Item.find(params[:item_id])
    if item.update(item_params)
      flash[:succes] = "Item has been updated"
      redirect_to "/merchant/items"
    else
      flash[:error] = item.errors.full_messages
      redirect_to "/merchant/items/#{item.id}/edit"
    end
  end

  private
  def item_params
    if params[:image].empty?
      params[:image] = "https://cateringbywestwood.com/wp-content/uploads/2015/11/dog-placeholder.jpg"
    end
    params.permit(:name, :description, :price, :image, :inventory)
  end
end
