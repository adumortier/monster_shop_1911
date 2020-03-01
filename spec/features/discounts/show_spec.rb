require 'rails_helper'

RSpec.describe "As a merchant employee", type: :feature do 

  describe 'when I visit my merchant dashboard' do 

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

    it 'I can click on an item name to see its information' do 
      
      expect(current_path).to eq('/merchant')

      click_link 'My Discounts'

      within("div#discount-#{@discount1.id}") do 
        click_link(@discount1.name)
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")

      expect(page).to have_content("Name: #{@discount1.name}")
      expect(page).to have_content("Number of Items: #{@discount1.number_items}")
      expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(@discount1.percent, precision:1)}")
      expect(page).to have_content("Created on: #{@discount1.created_at}")

      expect(page).to_not have_content("Name: #{@discount2.name}")
      expect(page).to_not have_content("Name: #{@discount3.name}")
    end

  end

end