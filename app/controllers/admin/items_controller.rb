class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @user_input ||= Hash.new("")
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      flash[:success] = "Item has been saved"
      redirect_to "/admin/merchants/#{item.merchant.id}/items"
    else
      @user_input = item_params
      flash[:errors] = item.errors.full_messages
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      flash[:succes] = "Item has been updated"
      redirect_to "/admin/merchants/#{item.merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages
      redirect_to "/admin/merchants/#{item.merchant.id}/items/#{item.id}/edit"
    end
  end

  def destroy
    item = Item.find(params[:id])
    if item.no_orders?
      item.delete
      flash[:success] = "Item has been deleted"
    else
      flash[:error] = "Item has been ordered before and cannot be deleted"
    end
    redirect_to "/admin/merchants/#{item.merchant.id}/items"
  end

  private
  def item_params
    if params[:image].empty?
      params[:image] = "https://cateringbywestwood.com/wp-content/uploads/2015/11/dog-placeholder.jpg"
    end
    params.permit(:name, :description, :price, :image, :inventory)
  end
end
