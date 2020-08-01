require "rails_helper"

RSpec.describe "As an Admin" do
  before :each do
    @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
  end

  it "displays all the merchant info" do
    visit "/merchants"
    click_on "Brian's Dog Shop"
    expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}")
    expect(page).to have_content(@dog_shop.name)
    expect(page).to have_content(@dog_shop.address)
    expect(page).to have_content(@dog_shop.city)
    expect(page).to have_content(@dog_shop.state)
    expect(page).to have_content(@dog_shop.zip)
  end
end
