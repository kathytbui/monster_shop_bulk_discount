class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def discounted_subtotal(item)
    discount = item.discounts.where('quantity <= ?', @contents[item.id.to_s]).order(percentage: :desc).first
    if discount.nil?
      item.price * @contents[item.id.to_s]
    elsif
      non_discount_items = @contents[item.id.to_s] - discount.quantity
      (discount.quantity * item.price * (1-discount.percentage)) + (item.price * non_discount_items)
    end
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    items = []
    @contents.keys.each do |key|
      items << Item.find(key)
    end
    items.reduce(0) do |acc, item|
      acc += discounted_subtotal(item)
      acc
    end
  end
end
