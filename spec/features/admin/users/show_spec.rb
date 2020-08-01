require 'rails_helper'

RSpec.describe "Users Index Page" do
  describe "as an admin" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @john = User.create!(name: "John", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
      @admin = User.create!(name: "Admin", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "realadmin@example.com", password: "password", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@admin)
    end
    it "displays the user show page without a link to edit" do
      visit "/admin/users/#{@john.id}"

      expect(page).to have_content(@john.name)
      expect(page).to have_content(@john.city)
      expect(page).to have_content(@john.state)
      expect(page).to have_content(@john.zip)
      expect(page).to have_content(@john.address)
      expect(page).to have_content(@john.email)
      expect(page).to_not have_content(@john.password)

      expect(page).to_not have_content("Edit Profile")
      expect(page).to_not have_content("Edit Password")
    end
  end
end
