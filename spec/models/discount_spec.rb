require "rails_helper"

RSpec.describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :percentage }
  end

  describe "relationships" do
    it { should have_many :item_discounts }
    it { should have_many(:items).through(:item_discounts) }
  end

  describe "methods" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user_1)
      @discount = Discount.create!(quantity: 5, percentage: 0.05)
      @item_discount_1 = ItemDiscount.create!(item: @pull_toy, discount: @discount)
      @discount_params = {
        quantity: "5",
        percentage: "0.2"
      }
      @discount_params_1 = {
        quantity: "5",
        percentage: "0.05"
      }
    end
    it "#create" do
      expect(Discount.create?(@discount_params).class).to eq(Discount)
      expect(Discount.create?(@discount_params)).to_not eq(@discount)
      expect(Discount.create?(@discount_params_1)).to eq(@discount)
    end
  end
end
