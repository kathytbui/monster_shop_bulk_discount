require "rails_helper"

RSpec.describe "Merchant Order Show Page" do
  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 1, merchant: @dog_shop)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @order = @user.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
    ItemOrder.create(item: @pull_toy, order: @order, quantity: 7, price: 10)
    ItemOrder.create(item: @chain, order: @order, quantity: 1, price: 50)

  end

  it "displays a list of pending orders that merchant currently sell" do
    visit "/merchant/dashboard"
    expect(page).to have_content("Order placed at: #{@order.created_at}")
    expect(page).to have_content("Total number of items: 7")
    expect(page).to have_content("Grand Total: $70.00")
    click_on "Order ID##{@order.id}"
    expect(current_path).to eq("/merchant/orders/#{@order.id}")
  end
  it "order show page displays order info and shipping info" do
    visit "/merchant/dashboard"
    click_on "Order ID##{@order.id}"
    expect(current_path).to eq("/merchant/orders/#{@order.id}")

    expect(page).to have_content(@order.name)
    expect(page).to have_content(@order.address)
    expect(page).to have_content(@order.city)
    expect(page).to have_content(@order.state)
    expect(page).to have_content(@order.zip)

    expect(page).to have_link(@pull_toy.name)
    expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    expect(page).to have_content(@pull_toy.price)
    expect(page).to have_content("Quantity: 7")
    expect(page).to_not have_content(@chain.name)

    click_on @pull_toy.name
    expect(current_path).to eq("/merchant/items/#{@pull_toy.id}")
  end
  it "has links to fulfill item orders based on status and item inventory" do
    visit "/items/#{@pull_toy.id}"
    expect(page).to have_content("32")

    visit "/merchant/orders/#{@order.id}"

    expect(page).to have_button("Fulfill Item")
    click_on "Fulfill Item"

    expect(current_path).to eq("/merchant/orders/#{@order.id}")

    expect(page).to have_content("Status: fulfilled")
    expect(page).to have_content("Item has been successfully fulfilled")

    visit "/items/#{@pull_toy.id}"
    expect(page).to have_content("25")
  end
  it "cannot fulfill an order due to lack of inventory" do
    @pull_toy.update(inventory: 1)
    visit "/merchant/orders/#{@order.id}"

    expect(page).to_not have_button("Fulfill Item")

    expect(page).to have_content("Inventory too low to fulfill order")
  end
end
