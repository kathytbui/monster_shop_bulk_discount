class AddStatusToItemOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :item_orders, :status, :integer
  end
end
