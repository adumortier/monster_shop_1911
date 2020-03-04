# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'when I visit my discounts index page' do
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

    it 'I can access a new discount form and create a new discount with valid arguments' do
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

      within("div#discount-#{@discount1.id}") do
        expect(page).to have_content("Name: #{@discount1.name}")
        expect(page).to have_content("Number of Items: #{@discount1.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(@discount1.percent, precision: 1)}")
      end

      within("div#discount-#{@discount2.id}") do
        expect(page).to have_content("Name: #{@discount2.name}")
        expect(page).to have_content("Number of Items: #{@discount2.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(@discount2.percent, precision: 1)}")
      end

      within("div#discount-#{new_discount.id}") do
        expect(page).to have_content("Name: #{new_discount.name}")
        expect(page).to have_content("Number of Items: #{new_discount.number_items}")
        expect(page).to have_content("Discount Percent: #{ActiveSupport::NumberHelper.number_to_percentage(new_discount.percent, precision: 1)}")
      end
      expect(page).to_not have_content("Name: #{@discount3.name}")

      expect(page).to have_content('Your new discount was saved')
    end

    it 'I can not create a new discount with invalid arguments' do

      visit '/merchant/discounts'
      click_link('Add Discount')
      expect(current_path).to eq('/merchant/discounts/new')

      fill_in :name, with: 'A discount with invalid fields'
      fill_in :number_items, with: 0
      fill_in :percent, with: 0.0

      last_discount = @merchant1.discounts.last

      click_button 'Submit'

      new_discount = @merchant1.discounts.last

      expect(new_discount).to eq(last_discount)

      expect(current_path).to eq('/merchant/discounts/new')

      expect(find_field('name').value).to eq("A discount with invalid fields")
      expect(find_field('number_items').value).to eq("0")
      expect(find_field('percent').value).to eq("0.0")

      expect(page).to have_content('Number items must be greater than 0')
      expect(page).to have_content('Percent must be greater than 0')

    end

    it 'I can not create a new discount with a percent larger than 100' do

      visit '/merchant/discounts'
      click_link('Add Discount')
      expect(current_path).to eq('/merchant/discounts/new')

      fill_in :name, with: 'A discount with invalid fields'
      fill_in :number_items, with: 0
      fill_in :percent, with: 120.0

      last_discount = @merchant1.discounts.last

      click_button 'Submit'

      new_discount = @merchant1.discounts.last

      expect(new_discount).to eq(last_discount)

      expect(current_path).to eq('/merchant/discounts/new')

      expect(find_field('name').value).to eq("A discount with invalid fields")
      expect(find_field('number_items').value).to eq("0")
      expect(find_field('percent').value).to eq("120.0")

      expect(page).to have_content('Number items must be greater than 0')
      expect(page).to have_content('Percent must be less than 100')

    end

    it 'I can not create a discount that conflicts with existing discounts' do

      visit '/merchant/discounts'
      click_link('Add Discount')
      expect(current_path).to eq('/merchant/discounts/new')

      fill_in :name, with: 'A discount with fields in conflict with other existing discount'
      fill_in :number_items, with: 15
      fill_in :percent, with: 7.0

      last_discount = @merchant1.discounts.last

      click_button 'Submit'

      new_discount = @merchant1.discounts.last

      expect(new_discount).to eq(last_discount)

      expect(current_path).to eq('/merchant/discounts/new')

      expect(find_field('name').value).to eq('A discount with fields in conflict with other existing discount')
      expect(find_field('number_items').value).to eq("15")
      expect(find_field('percent').value).to eq("7.0")

      expect(page).to have_content('The discount you tried to create is in conflict with existing discounts')

    end

  end
end
