require 'rails_helper'

RSpec.describe "As a visitor " , type: :feature do 

  describe "When I visit my discount show page" do 

    before(:each) do 
      @merchant_user = User.create!(name: 'Alex',
                                      street_address: '321 Jones Dr',
                                      city: 'Jonesville',
                                      state: 'WI',
                                      zip_code: 54_321,
                                      email: 'alex@example.com',
                                      password: 'alex123',
                                      role: 1)

      @merchant1 = create(:random_merchant)
      @merchant1.users << @merchant_user

      @merchant2 = create(:random_merchant)

      @discount1 = @merchant1.discounts.create!(name: "winter special", number_items: 10, percent: 15)
      @discount2 = @merchant1.discounts.create!(name: "big sale", number_items: 5, percent: 10)
      @discount3 = @merchant2.discounts.create!(name: "Huge sale", number_items: 30, percent: 20)

      visit "/login"
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password
      click_button "Log In"
    end

    it "I can delete the item" do 

      visit "/merchant/discounts"

      within("div#discount-#{@discount1.id}") do 
        click_link(@discount1.name)
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")

      click_link("Delete")

      expect(current_path).to eq("/merchant/discounts")

      expect(page).to_not have_content(@discount1.name)

    end
    
  end

end