require 'rails_helper'

RSpec.describe "User Orders Index page" do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
    @order_1 = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
    @order_2 = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)

    @item_order1 = ItemOrder.create!(order: @order_1, item: @paper, price: 20, quantity: 1)
    @item_order2 = ItemOrder.create!(order: @order_1, item: @pencil, price: 2, quantity: 2)
    @item_order3 = ItemOrder.create!(order: @order_2, item: @paper, price: 20, quantity: 3)


    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  end
    it "I visit my Profile Orders page I can click on a link for order's show page" do
      visit "/profile/orders"

      expect(page).to have_link(@order_1.id)
      click_link "#{@order_1.id}"
      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end
    it "displays all information about the order" do
      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at)
      expect(page).to have_content(@order_1.updated_at)
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.total_quantity)
      expect(page).to have_content(@order_1.grandtotal)

      within "#item-#{@paper.id}" do
        expect(page).to have_content(@paper.name)
        expect(page).to have_content(@paper.description)
        expect(page).to have_content("1")
        expect(page).to have_content(@paper.price)
        expect(page).to have_content(@item_order1.subtotal)
        expect(page).to have_css("img[src*='#{@paper.image}']")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_content(@pencil.name)
        expect(page).to have_content(@pencil.description)
        expect(page).to have_content("2")
        expect(page).to have_content(@pencil.price)
        expect(page).to have_content(@item_order2.subtotal)
        expect(page).to have_css("img[src*='#{@pencil.image}']")
      end
    end
    it "allows user to cancel an order" do
      visit "/profile/orders/#{@order_1.id}"

      expect(page).to have_link("Cancel Order")

      click_on "Cancel Order"

      expect(current_path).to eq("/profile/orders")

      expect(page).to have_content("Your order is cancelled")

      within ".order-#{@order_1.id}" do
        expect(page).to have_content("cancelled")
      end

      expect(@order_1.status).to eq("cancelled")

      @order_1.item_orders.each do |item_order|
        expect(item_order.status).to eq("unfulfilled")
      end
      # - Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.
    end

    it "will show packaged if all items are fulfilled" do
      @item_order1.update(status: 3)
      @item_order2.update(status: 3)
      visit "/profile/orders/#{@order_1.id}"
      click_on "Update Order"

      expect(page).to have_content("packaged")
    end

end
