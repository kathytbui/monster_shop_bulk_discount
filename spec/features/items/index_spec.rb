require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @order_1 = Order.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)

      ItemOrder.create(item: @pull_toy, order: @order_1, quantity: 7, price: 43)
      ItemOrder.create(item: @tire, order: @order_1, quantity: 3, price: 89)
    end

    # xit "all items or merchant names are links" do
    #   visit '/items'
    #
    #   expect(page).to have_link(@tire.name)
    #   expect(page).to have_link(@tire.merchant.name)
    #   expect(page).to have_link(@pull_toy.name)
    #   expect(page).to have_link(@pull_toy.merchant.name)
    #   expect(page).to have_link(@dog_bone.name)
    #   expect(page).to have_link(@dog_bone.merchant.name)
    # end
    #
    # xit "I can see a list of all of the items "do
    #
    #   visit '/items'
    #
    #   within "#item-#{@tire.id}" do
    #     expect(page).to have_link(@tire.name)
    #     expect(page).to have_content(@tire.description)
    #     expect(page).to have_content("Price: $#{@tire.price}")
    #     expect(page).to have_content("Active")
    #     expect(page).to have_content("Inventory: #{@tire.inventory}")
    #     expect(page).to have_link(@meg.name)
    #     expect(page).to have_css("img[src*='#{@tire.image}']")
    #   end
    #
    #   within "#item-#{@pull_toy.id}" do
    #     expect(page).to have_link(@pull_toy.name)
    #     expect(page).to have_content(@pull_toy.description)
    #     expect(page).to have_content("Price: $#{@pull_toy.price}")
    #     expect(page).to have_content("Active")
    #     expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
    #     expect(page).to have_link(@brian.name)
    #     expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    #   end
    #
    #   within "#item-#{@dog_bone.id}" do
    #     expect(page).to have_link(@dog_bone.name)
    #     expect(page).to have_content(@dog_bone.description)
    #     expect(page).to have_content("Price: $#{@dog_bone.price}")
    #     expect(page).to have_content("Inactive")
    #     expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
    #     expect(page).to have_link(@brian.name)
    #     expect(page).to have_css("img[src*='#{@dog_bone.image}']")
    #   end
    # end

    it "it shows all enabled items and images as links" do
      visit '/items'

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")

      find(:xpath, "//a/img[@alt='Pull Toy: photo']/..").click

      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end
  end

  describe "When looking at the item index" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
      @plane = @bike_shop.items.create(name: "Plane", description: "Yerp", price: 17, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 89)
      @baklava = @bike_shop.items.create(name: "Baklava", description: "Flaky!", price: 78, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 43)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)

      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)

      @order_1 = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)

      ItemOrder.create(item: @pull_toy, order: @order_1, quantity: 7, price: 89)
      ItemOrder.create(item: @tire, order: @order_1, quantity: 3, price: 89)
      ItemOrder.create(item: @plane, order: @order_1, quantity: 6, price: 89)
      ItemOrder.create(item: @baklava, order: @order_1, quantity: 89, price: 89)
      ItemOrder.create(item: @dog_bone, order: @order_1, quantity: 65, price: 89)
      ItemOrder.create(item: @chain, order: @order_1, quantity: 1, price: 89)
    end

    it "has popularity statistics" do
      visit "/items"

      order = "#{@baklava.name} - Total Sold: 89\n#{@dog_bone.name} - Total Sold: 65\n#{@pull_toy.name} - Total Sold: 7\n#{@plane.name} - Total Sold: 6\n#{@tire.name} - Total Sold: 3"
      within "#pop" do
        expect(page).to have_content(order)
      end

      reverse_order = "#{@chain.name} - Total Sold: 1\n#{@tire.name} - Total Sold: 3\n#{@plane.name} - Total Sold: 6\n#{@pull_toy.name} - Total Sold: 7\n#{@dog_bone.name} - Total Sold: 65"
      within "#least_pop" do
        expect(page).to have_content(reverse_order)
      end
    end
  end
end
