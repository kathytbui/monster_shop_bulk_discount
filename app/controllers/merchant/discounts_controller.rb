class Merchant::DiscountsController < Merchant::BaseController

  def index
    @items = user.merchant.items
  end

  def new
    @items = user.merchant.items
  end

  def create
    discount = Discount.create?(discount_params)
    items = Item.find(item_ids)
    if items.all? { |item| item.inventory > params[:quantity].to_i}
      if discount.save || !discount.id.nil?
        items.each { |item| ItemDiscount.create(item: item, discount: discount) unless ItemDiscount.exists?(item: item, discount: discount) }
        flash[:notice] = "Discount Created!"
        redirect_to "/merchant/discounts"
      else
        flash[:notice] = "Information cannot be blank or outside parameters. Discount was not created."
        redirect_to "/merchant/discounts/new"
      end
    else
      flash[:notice] = "Cannot create discount for bulk quantity greater than inventory left"
      redirect_to "/merchant/discounts/new"
    end
  end

  private
  def discount_params
    params.permit(:quantity, :percentage)
  end

  def item_ids
    item_ids = params[:merchant][:item_id].reject!(&:empty?)
  end
end
