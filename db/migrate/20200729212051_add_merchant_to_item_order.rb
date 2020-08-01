class AddMerchantToItemOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :item_orders, :item_merchant_id, :integer
  end
end
