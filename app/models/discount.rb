 class Discount < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :percentage
  validates_numericality_of :quantity, greater_than: 0
  validates_numericality_of :percentage, greater_than: 0
  validates_numericality_of :percentage, less_than: 1

  has_many :item_discounts
  has_many :items, through: :item_discounts

  def self.create?(discount_params)
    params = {
      quantity: discount_params[:quantity].to_i,
      percentage: discount_params[:percentage].to_f
    }
    if Discount.exists?(params)
      Discount.where(params).first
    else
      Discount.create(params)
    end
  end
end
