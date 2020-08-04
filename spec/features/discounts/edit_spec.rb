require "rails_helper"

RSpec.describe "Discount Edit Page" do
  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 0)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user_1)
      @discount = Discount.create!(quantity: 5, percentage: 0.05)
      @item_discount_1 = ItemDiscount.create!(item: @pull_toy, discount: @discount)
      ItemDiscount.create!(item: @dog_bone, discount: @discount)
    end

    it "can edit item's bulk discount" do
      visit "/merchant/discounts"
      within(".item_discounts-#{@pull_toy.id}") do
        click_on("Edit Discount")
      end
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
      expect(page).to have_content(@item_discount_1.item.name)
      expect(find_field(:quantity).value).to eq("#{@item_discount_1.discount.quantity}")
      expect(find_field(:percentage).value).to eq("#{@item_discount_1.discount.percentage}")
      fill_in :quantity, with: 5
      fill_in :percentage, with: 0.1
      click_on "Submit"
      expect(current_path).to eq("/merchant/discounts")
    end

    it "can edit item's bulk discount with existing discount" do
      visit "/merchant/discounts"
      within(".item_discounts-#{@pull_toy.id}") do
        click_on("Edit Discount")
      end
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
      expect(page).to have_content(@item_discount_1.item.name)
      expect(find_field(:quantity).value).to eq("#{@item_discount_1.discount.quantity}")
      expect(find_field(:percentage).value).to eq("#{@item_discount_1.discount.percentage}")
      fill_in :quantity, with: 5
      fill_in :percentage, with: 0.05
      click_on "Submit"
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
    end

    it "cannot edit item's bulk discount with missing info" do
      visit "/merchant/discounts"
      within(".item_discounts-#{@pull_toy.id}") do
        click_on("Edit Discount")
      end
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
      expect(page).to have_content(@item_discount_1.item.name)
      expect(find_field(:quantity).value).to eq("#{@item_discount_1.discount.quantity}")
      expect(find_field(:percentage).value).to eq("#{@item_discount_1.discount.percentage}")
      fill_in :quantity, with: ""
      fill_in :percentage, with: ""
      click_on "Submit"
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
      expect(page).to have_content("Discount was not updated")
    end

    it "cannot edit item's bulk discount with bad info" do
      visit "/merchant/discounts"
      within(".item_discounts-#{@pull_toy.id}") do
        click_on("Edit Discount")
      end
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
      expect(page).to have_content(@item_discount_1.item.name)
      expect(find_field(:quantity).value).to eq("#{@item_discount_1.discount.quantity}")
      expect(find_field(:percentage).value).to eq("#{@item_discount_1.discount.percentage}")
      fill_in :quantity, with: 0
      fill_in :percentage, with: 2
      click_on "Submit"
      expect(current_path).to eq("/merchant/item_discounts/#{@item_discount_1.id}/edit")
      expect(page).to have_content("Discount was not updated")
    end
  end
end
