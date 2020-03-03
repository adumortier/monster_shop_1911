 require 'rails_helper'
 
 RSpec.describe "As a visitor" , type: :feature do 
 
   describe "When I visit the cart" do 
 
    before(:each) do 
      @merchant1 = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @merchant2 = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @discount1 = @merchant1.discounts.create!(name: "winter special", number_items: 2, percent: 5)
      @discount2 = @merchant1.discounts.create!(name: "big sale", number_items: 4, percent: 10)
      @paper = @merchant1.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @merchant2.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 25)
    end
 
    it "I see the bulk discounts and I'm entitled to" do 

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/cart"

      within("tr#cart-item-#{@paper.id}") do
        expect(page).to have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Add One More")
        expect(page).to have_content("winter special, 5.0% off")
        expect(page).to_not have_content("no discount applied, 0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Add One More")
        expect(page).to have_content("winter special, 5.0% off")
        expect(page).to_not have_content("no discount applied, 0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Add One More")
        expect(page).to_not have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to have_content("big sale, 10.0% off")
        click_button("Remove One From Cart")
        expect(page).to have_content("winter special, 5.0% off")
        expect(page).to_not have_content("no discount applied, 0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
      end

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      visit "/cart"

      within("tr#cart-item-#{@pencil.id}") do
        expect(page).to have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Add One More")
        expect(page).to have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Add One More")
        expect(page).to have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Add One More")
        expect(page).to have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
        click_button("Remove One From Cart")
        expect(page).to have_content("no discount applied, 0% off")
        expect(page).to_not have_content("winter special, 5.0% off")
        expect(page).to_not have_content("big sale, 10.0% off")
      end

    end
 
  end
 
end
