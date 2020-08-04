 class Item <ApplicationRecord
  before_destroy :destroy_item_discounts
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders
  has_many :item_discounts
  has_many :discounts, through: :item_discounts

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0

  def self.active_items
    Item.where(active?: true)
  end

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def enough_inventory?(order_quantity)
    inventory >= order_quantity
  end

  def update_inventory(order_quantity)
    self.inventory -= order_quantity
    self.save
  end

  def self.order_by_pop
    Item.joins(:item_orders).select('SUM(item_orders.quantity) AS sum_quantity, items.name').group('items.id').order('SUM(item_orders.quantity) desc').limit(5)
  end

  def self.order_by_least_pop
    Item.joins(:item_orders).select('SUM(item_orders.quantity) AS sum_quantity, items.name').group('items.id').order('SUM(item_orders.quantity)').limit(5)
  end

  def deactivate
    self.update(active?: false)
  end

  def activate
    self.update(active?: true)
  end

  def discounted_price(item_discount)
    (1 - item_discount.discount.percentage) * price
  end

  def has_discount?
    !item_discounts.empty?
  end

  private
  def destroy_item_discounts
    self.item_discounts.each do |id|
      id.destroy
    end
  end
end
