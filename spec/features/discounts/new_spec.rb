# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
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

      @discount1 = @merchant1.discounts.create!(name: 'winter special', number_items: 10, percent: 15)
      @discount2 = @merchant1.discounts.create!(name: 'big sale', number_items: 5, percent: 10)
      @discount3 = @merchant2.discounts.create!(name: 'Huge sale', number_items: 30, percent: 20)

      visit '/login'
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password
      click_button 'Log In'
    end

    it 'there is a link to create a new discount for my merchant' do
      visit '/merchant/discounts'

      click_link('Add Discount')
      expect(current_path).to eq('/merchant/discounts/new')

      fill_in :name, with: 'Super Sale'
      fill_in :number_items, with: 15
      fill_in :percent, with: 17

      last_discount = @merchant1.discounts.last

      click_button 'Submit'

      new_discount = @merchant1.discounts.last

      expect(new_discount).to_not eq(last_discount)

      expect(current_path).to eq('/merchant/discounts')

      new_discount = @merchant1.discounts.last

      within("div#discount-#{@discount1.id}") do
        expect(page).to have_content("Name: #{@discount1.name}")
        expect(page).to have_content("Number of Items: #{@discount1.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(@discount1.percent, precision: 1)}")
        expect(page).to have_content("Created on: #{@discount1.created_at}")
      end

      within("div#discount-#{@discount2.id}") do
        expect(page).to have_content("Name: #{@discount2.name}")
        expect(page).to have_content("Number of Items: #{@discount2.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(@discount2.percent, precision: 1)}")
        expect(page).to have_content("Created on: #{@discount2.created_at}")
      end

      within("div#discount-#{new_discount.id}") do
        expect(page).to have_content("Name: #{new_discount.name}")
        expect(page).to have_content("Number of Items: #{new_discount.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(new_discount.percent, precision: 1)}")
        expect(page).to have_content("Created on: #{new_discount.created_at}")
      end
      expect(page).to_not have_content("Name: #{@discount3.name}")

      expect(page).to have_content('Your new discount was saved')
    end
  end
end
