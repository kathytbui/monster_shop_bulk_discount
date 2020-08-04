require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it{should validate_presence_of :name}
    it{should validate_presence_of :address}
    it{should validate_presence_of :city}
    it{should validate_presence_of :state}
    it{should validate_presence_of :zip}
    it{should validate_presence_of :email}
    it{should validate_presence_of :password}
    it{should validate_uniqueness_of :email}
  end

  describe "relationships" do
    it { should have_many :orders}
    it { should belong_to(:merchant).optional}
  end

  describe "methods" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merchant@example.com", password: "password", role: 1, merchant: @dog_shop)
    end

    it "can determine user" do
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
    end
  end
end
