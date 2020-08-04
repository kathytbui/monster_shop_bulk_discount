require "rails_helper"

RSpec.describe "Discount Index Page" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user_1)
      @discount = Discount.create!(quantity: 5, percentage: 0.05)
      ItemDiscount.create!(item: @pull_toy, discount: @discount)
    end

    it "text" do
      visit "/merchant/dashboard"
      click_on "Manage My Discounts"
      expect(current_path).to eq("/merchant/discounts")
      within(".item_discounts-#{@pull_toy.id}") do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content("Original Price: $#{@pull_toy.price}.00")
        expect(page).to have_content("Discount Amount Required: 5")
        expect(page).to have_content("Discounted Price per Item: $#{@pull_toy.price * 0.95}0")
      end
    end
  end
end
