require "rails_helper"

RSpec.describe ItemDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :discount_id }
  end

  describe "relationships" do
    it { should belong_to :item }
    it { should belong_to :discount }
  end
end
