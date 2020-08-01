class Admin::DashboardController < Admin::BaseController

  def index
    @orders = Order.all
  end

  def update
    order = Order.find(params[:id])
    order.update(status: 3)
    redirect_to "/admin/dashboard"
  end
end
