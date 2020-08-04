class ItemOrder <ApplicationRecord
  after_initialize :default_status, :set_merchant
  validates_presence_of :item_id, :order_id, :price, :quantity
  belongs_to :item
  belongs_to :order

  enum status: %w(pending packaged unfulfilled fulfilled shipped cancelled)

  def subtotal
    item.price * quantity
  end

  def discounted_subtotal
    discount = item.discounts.where('quantity <= ?', self.quantity).order(percentage: :desc).first
    if discount.nil?
      item.price * quantity
    elsif
      non_discount_items = quantity - discount.quantity
      (discount.quantity * item.price * (1-discount.percentage)) + (item.price * non_discount_items)
    end
  end

  private

  def default_status
    self.status = 0 if status.nil?
  end

  def set_merchant
    if !item.nil?
      item = Item.find(self.item_id)
      self.item_merchant_id = item.merchant_id
    end
  end
end
