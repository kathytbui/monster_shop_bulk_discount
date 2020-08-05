require "rails_helper"

RSpec.describe "Discount New Page" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "t3@example.com", password: "password", role: 0)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user_1)
      @discount = Discount.create!(quantity: 5, percentage: 0.1)
    end

    it "can create a bulk discount" do
      visit "/merchant/dashboard"
      click_on "Manage My Discounts"
      expect(current_path).to eq("/merchant/discounts")
      expect(page).to_not have_content(@pull_toy.name)
      expect(page).to_not have_content(@dog_bone.name)
      click_on "Add New Discount"
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content("Original Price: $#{@pull_toy.price}.00")
      expect(page).to have_content("Current Inventory Amount: #{@pull_toy.inventory}")
      expect(page).to have_content(@dog_bone.name)
      expect(page).to have_content("Original Price: $#{@dog_bone.price}.00")
      expect(page).to have_content("Current Inventory Amount: #{@dog_bone.inventory}")
      check @pull_toy.name
      check @dog_bone.name
      fill_in :quantity, with: 5
      fill_in :percentage, with: 0.05
      click_on "Submit"
      expect(current_path).to eq("/merchant/discounts")
      within(".item_discounts-#{@pull_toy.id}") do
        expect(page).to have_content(@pull_toy.name)
      end
      within(".item_discounts-#{@dog_bone.id}") do
        expect(page).to have_content(@dog_bone.name)
      end
    end

    it "cannot create a discount if inventory is lower than desired bulk discount quantity" do
      visit "/merchant/discounts"
      click_on "Add New Discount"
      check @pull_toy.name
      check @dog_bone.name
      fill_in :quantity, with: 30
      fill_in :percentage, with: 0.05
      click_on "Submit"
      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Cannot create discount for bulk quantity greater than inventory left")
    end

    it "cannot create if any information is bad/missing
    As a merchant" do
      visit "/merchant/discounts"
      click_on "Add New Discount"
      check @pull_toy.name
      check @dog_bone.name
      click_on "Submit"
      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Information cannot be blank or outside parameters. Discount was not created.")
      check @pull_toy.name
      check @dog_bone.name
      fill_in :quantity, with: 5
      fill_in :percentage, with: 5
      click_on "Submit"
      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Information cannot be blank or outside parameters. Discount was not created.")
    end

    it "can create a bulk discount using a discount that already exists" do
      visit "/merchant/dashboard"
      click_on "Manage My Discounts"
      expect(current_path).to eq("/merchant/discounts")
      expect(page).to_not have_content(@pull_toy.name)
      click_on "Add New Discount"
      check @pull_toy.name
      fill_in :quantity, with: 5
      fill_in :percentage, with: 0.1
      click_on "Submit"
      expect(current_path).to eq("/merchant/discounts")
      within(".item_discounts-#{@pull_toy.id}") do
        expect(page).to have_content(@pull_toy.name)
      end
    end
  end

  describe "As a visitor" do
    before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "t2@example.com", password: "password", role: 0)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    @discount = Discount.create!(quantity: 5, percentage: 0.1)
    @discount_1 = Discount.create!(quantity: 10, percentage: 0.2)
    ItemDiscount.create(item: @pull_toy, discount: @discount)
    ItemDiscount.create(item: @pull_toy, discount: @discount_1)
    end

    it "can order bulk discount" do
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Buy #{@discount.quantity} to get #{@discount.percentage * 100}% off!")
      click_on "Add To Cart"
      visit "/cart"
      fill_in :quantity, with: 5
      click_on "Update Quantity"
      expect(page).to have_content("Total: $45.00")
    end

    it "can order bulk discount with higher discount" do
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Buy #{@discount.quantity} to get #{@discount.percentage * 100}% off!")
      expect(page).to have_content("Buy #{@discount_1.quantity} to get #{@discount_1.percentage * 100}% off!")
      click_on "Add To Cart"
      visit "/cart"
      fill_in :quantity, with: 10
      click_on "Update Quantity"
      expect(page).to have_content("Total: $80.00")
    end

    it "can order bulk discount with higher discount and additional items do not count" do
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Buy #{@discount.quantity} to get #{@discount.percentage * 100}% off!")
      expect(page).to have_content("Buy #{@discount_1.quantity} to get #{@discount_1.percentage * 100}% off!")
      click_on "Add To Cart"
      visit "/cart"
      fill_in :quantity, with: 11
      click_on "Update Quantity"
      expect(page).to have_content("Total: $90.00")
    end

    it "can order bulk discount with higher discount and additional items do not count" do
      order_1 = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
      ItemOrder.create(item: @pull_toy, order: order_1, quantity: 11, price: 10)
      visit "/orders/#{order_1.id}"
      expect(page).to have_content("$90.00")
    end
  end
end
