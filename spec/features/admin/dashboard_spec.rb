require 'rails_helper'

RSpec.describe "When I visit the admin dashboard" do
  before :each do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
    @order_1 = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890, status: 0)
    @order_2 = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890, status: 1)

    @item_order1 = ItemOrder.create!(order: @order_1, item: @paper, price: 20, quantity: 1)
    @item_order2 = ItemOrder.create!(order: @order_1, item: @pencil, price: 2, quantity: 2)
    @item_order3 = ItemOrder.create!(order: @order_2, item: @paper, price: 20, quantity: 3)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
  end

  it "has all orders sorted by status" do

    visit '/admin/dashboard'

    expect(page).to have_content(@order_1.name)
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_1.created_at)

    expect(page).to have_content(@order_2.name)
    expect(page).to have_content(@order_2.id)
    expect(page).to have_content(@order_2.created_at)

    expect("Order Id: #{@order_2.id}").to appear_before("Order Id: #{@order_1.id}")
  end

  it "has a button to ship orders" do
    visit '/admin/dashboard'

    click_on "Ship Order"

    expect(current_path).to eq("/admin/dashboard")

    expect("Order Id: #{@order_1.id}").to appear_before("Order Id: #{@order_2.id}")
  end
end
