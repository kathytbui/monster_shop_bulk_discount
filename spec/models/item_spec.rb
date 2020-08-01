require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
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

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "#collects active_items" do
      expect(Item.active_items).to eq([@chain, @tire, @pull_toy, @dog_bone, @plane, @baklava])
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      expect(chain.no_orders?).to eq(true)
      order = @user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: chain, price: chain.price, quantity: 2)
      expect(chain.no_orders?).to eq(false)
    end

    it "#order_by_pop" do
      order = [@baklava.name, @dog_bone.name, @pull_toy.name, @plane.name, @tire.name]
      expect(Item.order_by_pop.pluck(:name)).to eq(order)
    end

    it "#order_by_least_pop" do
      order = [@chain.name, @tire.name, @plane.name, @pull_toy.name, @dog_bone.name]
      expect(Item.order_by_least_pop.pluck(:name)).to eq(order)
    end

    it "#deactivate" do
      @pull_toy.deactivate
      expect(@pull_toy.active?).to eq(false)
    end

    it "#activate" do
      @pull_toy.deactivate
      expect(@pull_toy.active?).to eq(false)
      @pull_toy.activate
      expect(@pull_toy.active?).to eq(true)
    end

    it "can check for enough inventory" do
      expect(@pull_toy.enough_inventory?(1)).to eq(true)
      expect(@pull_toy.enough_inventory?(1000)).to eq(false)
    end

    it "update_inventory" do
      @pull_toy.update_inventory(1)
      expect(@pull_toy.inventory).to eq(31)
    end
  end
end
