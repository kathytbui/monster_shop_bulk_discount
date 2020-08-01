class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = user.merchant
  end
end
