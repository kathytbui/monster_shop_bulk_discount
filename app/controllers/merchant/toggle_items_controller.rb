class Merchant::ToggleItemsController < Merchant::BaseController

  def update
    item = Item.find(params[:item_id])
    if item.active?
      item.deactivate
      flash[:success] = "Item is no longer for sale"
    else
      item.activate
      flash[:success] = "Item is now available for sale"
    end
    redirect_to "/merchant/items"
  end
end
