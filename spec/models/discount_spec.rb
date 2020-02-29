require 'rails_helper'

RSpec.describe Discount, type: :model do 

  describe 'validations' do 
    it { should validate_presence_of :name}
    it { should validate_presence_of :number_items}
    it { should validate_presence_of :percent}
  end 

  describe 'relationships' do 
    it { should belong_to :merchant }
  end 

  describe 'methods' do 
    it '#valid_discount?' do 
      @merchant1 = create(:random_merchant)
      @discount1 = @merchant1.discounts.create!(name: 'winter special', number_items: 10, percent: 15)
      @discount2 = @merchant1.discounts.create!(name: 'big sale', number_items: 5, percent: 10)
      @discount3 = @merchant1.discounts.create!(name: 'Huge sale', number_items: 20, percent: 12)
      expect(@discount3.valid_discount?).to eq(false)
      @discount4 = @merchant1.discounts.create!(name: 'Huge sale', number_items: 2, percent: 12)
      expect(@discount4.valid_discount?).to eq(false)
    end
  end


end