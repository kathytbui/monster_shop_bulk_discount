class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :quantity
      t.float :percentage
      t.timestamps
    end
  end
end
