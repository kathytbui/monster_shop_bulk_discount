class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def destroy
    merchant = Merchant.find(params[:id])
    merchant.update(status: 1)
    merchant.deactivate_all_items
    flash[:success] = "Merchant has been disabled"
    redirect_to "/admin/merchants"
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(status: 0)
    merchant.activate_all_items
    flash[:success] = "Merchant's account is now enabled"
    redirect_to "/admin/merchants"
  end
end
