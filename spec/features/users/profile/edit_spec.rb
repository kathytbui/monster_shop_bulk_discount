require 'rails_helper'

describe "When a visitor goes to their profile page" do
  before :each do
    @tanya = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")
    User.create!(name: "Gerald", address: "786 Helper ln", city: "Luftwaffe", state: "Germany_ville", zip: "78766", email: "danka@gmail.com", password: "Footies")

    visit "/login"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    click_on "Log In"
  end

  it "shows all data and a link to edit" do
    expect(current_path).to eq("/profile")

    click_on "Edit Profile"

    expect(find_field(:name).value).to eq('Tanya')
    expect(find_field(:address).value).to eq('145 Uvula dr')
    expect(find_field(:city).value).to eq('Lake')
    expect(find_field(:state).value).to eq('Michigan')
    expect(find_field(:zip).value).to eq('77967')
    expect(find_field(:email).value).to eq('T-tar@gmail.com')
  end

  it "won't change an email to one that is taken" do
    click_on "Edit Profile"

    fill_in :email, with: "danka@gmail.com"

    click_on "Submit"
    expect(current_path).to eq("/profile/edit")
    expect(page).to have_content("Email has already been taken")
  end

  it "won't change a password if not confirmed" do
    click_on "Edit Password"

    fill_in :password, with: "password"
    fill_in :c_password, with: "passwordfsf"

    click_on "Submit"
    expect(current_path).to eq("/profile/password_edit")
    expect(page).to have_content("Passwords must match")
  end
end
