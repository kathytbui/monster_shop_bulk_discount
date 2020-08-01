require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merch@example.com", password: "password", role: 1, merchant: @dog_shop)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    end

    it "displays the name and full address of the merchant they work for" do
      visit "/admin/merchants/#{@user_1.merchant.id}"
      expect(page).to have_content(@user_1.merchant.name)
      expect(page).to have_content(@user_1.merchant.address)
      expect(page).to have_content(@user_1.merchant.city)
      expect(page).to have_content(@user_1.merchant.state)
      expect(page).to have_content(@user_1.merchant.zip)
    end

    it "displays a link to view merchant's items" do
      visit "/admin/merchants/#{@user_1.merchant.id}"
      click_on "My Items"
      expect(current_path).to eq("/admin/merchants/#{@user_1.merchant.id}/items")
    end
  end
end
