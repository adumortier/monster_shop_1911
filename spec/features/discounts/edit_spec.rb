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

    it 'there is a link to edit the discounts of my merchant' do 
      
      expect(current_path).to eq('/merchant')

      click_link 'My Discounts'

      within("div#discount-#{@discount1.id}") do 
        expect(page).to have_link("Edit")
      end

      old_discount2 = @discount2

      within("div#discount-#{@discount2.id}") do 
        click_link("Edit")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      fill_in :name, with: 'A legit discount'
      fill_in :number_items, with: 15
      fill_in :percent, with: 20.0

      click_button("Update")

      expect(page).to have_content('Your discount was updated successfully')

      new_discount2 = @discount2

      expect(current_path).to eq('/merchant/discounts')

      within("div#discount-#{@discount1.id}") do 
        expect(page).to have_content("Name: #{@discount1.name}")
        expect(page).to have_content("Number of Items: #{@discount1.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(@discount1.percent, precision:1)}")
      end

      within("div#discount-#{@discount2.id}") do 
        expect(page).to have_content("Name: A legit discount")
        expect(page).to have_content("Number of Items: 15")
        expect(page).to have_content("Discount Percent: 20.0%")
        expect(page).to_not have_content("Name: #{old_discount2.name}")
        expect(page).to_not have_content("Number of Items: #{old_discount2.number_items}")
        expect(page).to_not have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(old_discount2.percent, precision:1)}")
      end

    end

    it 'I can not edit a discount with invalid fields' do 
      
      expect(current_path).to eq('/merchant')

      click_link 'My Discounts'

      within("div#discount-#{@discount2.id}") do 
        click_link("Edit")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      fill_in :name, with: 'A not legit discount'
      fill_in :number_items, with: 0
      fill_in :percent, with: 0.0

      click_button("Update")

      expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      visit '/merchant/discounts'

      expect(page).to_not have_content("Name: A not legit discount")
      expect(page).to_not have_content("Number of Items: 0")
      expect(page).to_not have_content("Discount Percent: 0.0%")

    end

    it 'I can not edit a discount in a way that would put it in conflict with other existing discounts' do 
      
      expect(current_path).to eq('/merchant')

      click_link 'My Discounts'

      within("div#discount-#{@discount2.id}") do 
        click_link("Edit")
      end

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      fill_in :name, with: 'A not legit discount'
      fill_in :number_items, with: 6
      fill_in :percent, with: 20.0

      click_button("Update")

      expect(page).to have_content('This discount would be in conflict with existing discounts')

      expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      visit '/merchant/discounts'

      expect(page).to_not have_content("Name: A not legit discount")
      expect(page).to_not have_content("Number of Items: 0")
      expect(page).to_not have_content("Discount Percent: 0.0%")

    end

    it 'I can not edit a discount to give it the same parameters as another existing discount' do 
      
      expect(current_path).to eq('/merchant')

      click_link 'My Discounts'

      within("div#discount-#{@discount2.id}") do 
        click_link("Edit")
      end

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      fill_in :name, with: 'A not legit discount'
      fill_in :number_items, with: 10
      fill_in :percent, with: 15.0

      click_button("Update")

      expect(page).to have_content('This discount would be in conflict with existing discounts')

      expect(current_path).to eq("/merchant/discounts/#{@discount2.id}/edit")

      expect(find_field('name').value).to eq(@discount2.name)
      expect(find_field('number_items').value).to eq(@discount2.number_items.to_s)
      expect(find_field('percent').value).to eq(@discount2.percent.to_s)

      visit '/merchant/discounts'

      expect(page).to_not have_content("Name: A not legit discount")
      expect(page).to_not have_content("Number of Items: 0")
      expect(page).to_not have_content("Discount Percent: 0.0%")

    end


  end
end
