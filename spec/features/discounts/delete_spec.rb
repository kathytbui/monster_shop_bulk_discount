require "rails_helper"

RSpec.describe "Delete discount" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user_1)
    @discount = Discount.create!(quantity: 5, percentage: 0.05)
    @item_discount_1 = ItemDiscount.create!(item: @pull_toy, discount: @discount)
  end

  it "can delete a discount" do
    visit "/merchant/discounts"
    within(".item_discounts-#{@pull_toy.id}") do
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content("Discounted Price per Item: $9.50")
      click_on("Delete Discount")
    end
    expect(current_path).to eq("/merchant/discounts")
    expect(page).to_not have_content("Discount Price per Item: $9.50")
  end

  it "can delete item_discount if item is deleted" do
    visit "/merchant/items/#{@pull_toy.id}"
    click_on "Delete Item"
    visit "/merchant/discounts"
    expect(page).to_not have_content(@pull_toy.name)
  end
end
