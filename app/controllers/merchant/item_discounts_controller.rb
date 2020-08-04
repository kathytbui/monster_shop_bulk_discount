class Merchant::ItemDiscountsController < Merchant::BaseController

  def edit
    @item_discount = ItemDiscount.find(params[:id])
  end

  def update
    item_discount = ItemDiscount.find(params[:id])
    discount = Discount.create?(discount_params)
    if ItemDiscount.exists?(item: item_discount.item, discount: discount)
      flash[:error] = "Discount already applied to item previously"
      redirect_to "/merchant/item_discounts/#{item_discount.id}/edit"
    else
      new_discount = ItemDiscount.create(item: item_discount.item, discount: discount)
      if !discount.nil? && new_discount.save
        item_discount.destroy
        flash[:success] = "New discount applied to item!"
        redirect_to "/merchant/discounts"
      else
        flash[:error] = "Discount was not updated, input incorrect"
        redirect_to "/merchant/item_discounts/#{item_discount.id}/edit"
      end
    end
  end

  def destroy
    ItemDiscount.destroy(params[:id])
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:quantity, :percentage)
  end
end
