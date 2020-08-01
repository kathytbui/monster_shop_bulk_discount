require "rails_helper"

RSpec.describe "User Login" do
  describe "As a visitor" do
    it "displays a path to user login" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

      expect(user.default?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{user.name}!")
    end

    it "displays a path to merchant login" do
      visit "/login"
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 1, merchant: @dog_shop)

      expect(user.merchant?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/merchant/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")
    end

    it "displays a path to merchant login" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 2)

      expect(user.admin?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")
    end

    it "users cannot login with bad credentials" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

      expect(user.default?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "password"
      click_on "Log In"
      expect(current_path).to eq("/login")
      expect(page).to have_content("Sorry, your credentials are bad.")
    end

    it "users who are already logged in are redirected" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

      expect(user.default?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/login"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are already logged in")
    end

    it "merchants who are already logged in are redirected" do
      visit "/login"
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 1, merchant: @dog_shop)

      expect(user.merchant?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/merchant/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/login"
      expect(current_path).to eq("/merchant/dashboard")
      expect(page).to have_content("You are already logged in")
    end

    it "admins who are already logged in are redirected" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 2)

      expect(user.admin?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/login"
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content("You are already logged in")
    end

    it "users who are already logged can log out" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      expect(user.default?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/items/#{tire.id}"
      click_on "Add To Cart"
      expect(page).to have_content("Cart: 1")

      click_on "Log Out"
      expect(current_path).to eq("/")
      expect(page).to have_content("You have successfully logged out")
      expect(page).to have_content("Cart: 0")
    end

    it "merchants who are already logged can log out" do
      visit "/login"
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 1, merchant: @dog_shop)

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      expect(user.merchant?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/merchant/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/items/#{tire.id}"
      click_on "Add To Cart"
      expect(page).to have_content("Cart: 1")

      click_on "Log Out"
      expect(current_path).to eq("/")
      expect(page).to have_content("You have successfully logged out")
      expect(page).to have_content("Cart: 0")
    end

    it "admins who are already logged can log out" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 2)

      expect(user.admin?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")

      click_on "Log Out"
      expect(current_path).to eq("/")
      expect(page).to have_content("You have successfully logged out")
    end
  end
end
