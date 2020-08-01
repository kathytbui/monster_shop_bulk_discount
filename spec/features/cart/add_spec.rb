require 'rails_helper'

RSpec.describe 'Cart creation' do
  describe 'When I visit an items show page' do

    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    end

    it "I see a link to add this item to my cart" do
      visit "/items/#{@paper.id}"
      expect(page).to have_button("Add To Cart")
    end

    it "I can add this item to my cart" do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      expect(page).to have_content("#{@paper.name} was successfully added to your cart")
      expect(current_path).to eq("/items")

      within 'nav' do
        expect(page).to have_content("Cart: 1")
      end

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      within 'nav' do
        expect(page).to have_content("Cart: 2")
      end
    end
  end
  describe "As a visitor when I have items in my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end
    it "And I visit my cart, each item has a button or link to increment the count of items, cannot increment the count beyond the item's inventory" do

      visit '/cart'

      @items_in_cart.each do |item|
        within "#cart-item-#{item.id}" do
          expect(page).to have_link(item.name)
          expect(page).to have_css("img[src*='#{item.image}']")
          expect(page).to have_link("#{item.merchant.name}")
          expect(page).to have_content("$#{item.price}")
          expect(page).to have_content("1")
          expect(page).to have_content("$#{item.price}")
        end
      end
      within "#cart-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content("1")
        fill_in :quantity, with: "5"
        click_on "Update Quantity"
        expect(current_path).to eq("/cart")
        expect(page).to have_content("5")
        fill_in :quantity, with: "999"
        click_on "Update Quantity"
        expect(page).to have_content("5")
      end
    end

    it "And I visit my cart, each item has a button or link to decrement the count of items, cannot decrease the count below the item's inventory" do
      visit '/cart'

      within "#cart-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content("1")
        fill_in :quantity, with: "2"
        click_on "Update Quantity"
        expect(current_path).to eq("/cart")
        expect(page).to have_content("2")
        fill_in :quantity, with: "1"
        click_on "Update Quantity"
        expect(current_path).to eq("/cart")
        expect(page).to have_content("1")
        fill_in :quantity, with: "-1"
        click_on "Update Quantity"
        expect(page).to have_content("1")
      end
    end
    it "And I visit my cart, setting counter to 0 removes item from cart" do
      visit '/cart'

      within "#cart-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content("1")
        fill_in :quantity, with: "0"
        click_on "Update Quantity"
      end
      expect(current_path).to eq("/cart")
      expect(page).to_not have_content(@tire.name)
    end
    it "Prompts Visitors to register to finish checkout" do
      visit "/cart"

      expect(page).to have_content("Please Register or Log In to checkout")
      within ".cart-checkout" do
        expect(page).to have_link("Register")
        expect(page).to have_link("Log In")
      end
    end
  end
end
