class ItemDiscount < ApplicationRecord
  validates_presence_of :item_id
  validates_presence_of :discount_id

  belongs_to :item
  belongs_to :discount
end
