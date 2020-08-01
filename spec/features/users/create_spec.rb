require 'rails_helper'

RSpec.describe "When I use the navbar to register a user" do
  it "takes me to a form to fill out info" do
    visit "/merchants"

    within 'nav' do
      click_link "Register"
    end

    expect(current_path).to eq('/register')

    fill_in :name, with: "Tanya"
    fill_in :address, with: "145 Uvula dr"
    fill_in :city, with: "Lake"
    fill_in :state, with: "Michigan"
    fill_in :zip, with: "77967"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    fill_in :c_password, with: "Bangladesh134"
    click_on "Submit"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Welcome to the black market")
  end

  it "flashes spcific error messages when info is missing" do
    visit "/merchants"

    within 'nav' do
      click_link "Register"
    end

    expect(current_path).to eq('/register')
    click_on "Submit"
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Address can't be blank")
    expect(page).to have_content("City can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")

    expect(current_path).to eq('/register')
  end

  it "requires unique emails for registration" do
    visit "/merchants"

    within 'nav' do
      click_link "Register"
    end

    expect(current_path).to eq('/register')

    user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

    fill_in :name, with: "Tanya"
    fill_in :address, with: "145 Uvula dr"
    fill_in :city, with: "Lake"
    fill_in :state, with: "Michigan"
    fill_in :zip, with: "77967"
    fill_in :email, with: "T-tar@gmail.com"
    fill_in :password, with: "Bangladesh134"
    fill_in :c_password, with: "Bangladesh134"
    click_on "Submit"

    expect(current_path).to eq('/register')

    expect(find_field(:name).value).to eq('Tanya')
    expect(find_field(:address).value).to eq('145 Uvula dr')
    expect(find_field(:city).value).to eq('Lake')
    expect(find_field(:state).value).to eq('Michigan')
    expect(find_field(:zip).value).to eq('77967')
    expect(find_field(:email).value).to eq('T-tar@gmail.com')

    fill_in :email, with: "Tanya@gmail.com"
    fill_in :password, with: "Bangladesh134"
    fill_in :c_password, with: "Bangladesh134"
    click_on "Submit"
    expect(current_path).to eq('/profile')

  end

  it "flashes spcific error messages when passwords dont match" do
    visit "/merchants"

    within 'nav' do
      click_link "Register"
    end

    expect(current_path).to eq('/register')

    fill_in :name, with: "John"
    fill_in :address, with: "hoho"
    fill_in :city, with: "Johnville"
    fill_in :state, with: "Johntucky"
    fill_in :zip, with: 69870

    fill_in :password, with: "password"
    fill_in :c_password, with: "super"
    click_on "Submit"

    expect(current_path).to eq('/register')
    expect(page).to have_content("Passwords must match")
  end
end
