require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 1, merchant: @dog_shop)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    end

    it "displays the name and full address of the merchant they work for" do
      visit "/merchant/dashboard"
      expect(page).to have_content(@dog_shop.name)
      expect(page).to have_content(@dog_shop.address)
      expect(page).to have_content(@dog_shop.city)
      expect(page).to have_content(@dog_shop.state)
      expect(page).to have_content(@dog_shop.zip)
    end

    it "displays a link to view merchant's items" do
      visit "/merchant/dashboard"
      click_on "My Items"
      expect(current_path).to eq("/merchant/items")
    end
  end
end
