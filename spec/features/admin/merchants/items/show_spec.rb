require "rails_helper"

RSpec.describe "Merchant Order Show Page" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
    @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merch@example.com", password: "password", role: 1, merchant: @dog_shop)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @order = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
    ItemOrder.create(item: @pull_toy, order: @order, quantity: 7, price: 54)
  end

  it "displays a list of pending orders that merchant currently sell" do
    visit "/admin/merchants/#{@user_1.merchant.id}"
    expect(page).to have_content("Order placed at: #{@order.created_at}")
    expect(page).to have_content("Total number of items: #{@order.total_quantity }")
    expect(page).to have_content("Grand Total: #{@order.grandtotal}")
    click_on "Order ID##{@order.id}"
    expect(current_path).to eq("/merchant/orders/#{@order.id}")
  end
end
