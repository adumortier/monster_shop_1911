require 'rails_helper'

RSpec.describe "Profile show page", type: :feature do
  before(:each) do
    @default_user = User.create!(name: "Saul Goodman",
      street_address: "123 Magic St",
      city: "Albuquerque",
      state: 'NM',
      zip_code: 44565,
      email: "bettercallsaul@example.com",
      password: "mike01",
      role: 0
    )

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)
  end
  it "shows all user data in profile show page" do

    visit '/profile'
    save_and_open_page

    click_link("Edit Profile")

    expect(find_field(:name).value).to eq(@default_user.name)
    expect(find_field(:street_address).value).to eq(@default_user.street_address)
    expect(find_field(:city).value).to eq(@default_user.city)
    expect(find_field(:state).value).to eq(@default_user.state)
    expect(find_field(:zip_code).value).to eq(@default_user.zip_code)
    expect(find_field(:email).value).to eq(@default_user.email)

    fill_in :name, with: "Honey"
    fill_in :street_address, with: "Honey Nut St"
    fill_in :city, with: "Honeyville"
    fill_in :state, with: "Hawaii"
    fill_in :zip_code, with: "12222"

    click_on("Update Profile")

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your profile has been updated")
    expect(page).to have_content("Honey")
    expect(page).to have_content("Honey Nut St")
    expect(page).to have_content("Honeyville")
    expect(page).to have_content("Hawaii")
    expect(page).to have_content("12222")
  end
end
