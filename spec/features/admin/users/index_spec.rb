require 'rails_helper'

RSpec.describe "Users Index Page" do
  describe "as an admin" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @john = User.create!(name: "John", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
      @user_0 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "user@example.com", password: "password", role: 0)
      @user_1 = User.create!(name: "Tonya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
      @user_2 = User.create!(name: "Tonyo", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "admin@example.com", password: "password", role: 0)
      @admin = User.create!(name: "Admin", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "realadmin@example.com", password: "password", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@admin)
    end
    it "lists all the users in the system" do
      visit '/items'
      click_on "Users"

      expect(current_path).to eq("/admin/users")

      within ".user-#{@john.id}" do
        expect(page).to have_link(@john.name)
        expect(page).to have_content(@john.created_at)
        expect(page).to have_content(@john.role)
      end

      within ".user-#{@user_0.id}" do
        expect(page).to have_link(@user_0.name)
        expect(page).to have_content(@user_0.created_at)
        expect(page).to have_content(@user_0.role)
      end

      within ".user-#{@user_1.id}" do
        expect(page).to have_link(@user_1.name)
        expect(page).to have_content(@user_1.created_at)
        expect(page).to have_content(@user_1.role)
      end

      within ".user-#{@admin.id}" do
        expect(page).to have_link(@admin.name)
        expect(page).to have_content(@admin.role)
        expect(page).to have_content(@admin.name)
      end
    end
  end
end

# When I click the "Users" link in the nav (only visible to admins)
# Then my current URI route is "/admin/users"
# Only admin users can reach this path.
# I see all users in the system
# Each user's name is a link to a show page for that user ("/admin/users/5")
# Next to each user's name is the date they registered
# Next to each user's name I see what type of user they are
