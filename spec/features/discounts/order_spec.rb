require 'rails_helper'

RSpec.describe "Order creating with discounts " , type: :feature do 

  describe "When I " do 

    before(:each) do 
      @default_user = User.create!(name: "Bert",
                                  street_address: "123 Sesame St.",
                                  city: "NYC",
                                  state: "New York",
                                  zip_code: 10001,
                                  email: "erniesroomie@example.com",
                                  password: "paperclips800",
                                  role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)

      @merchant1 = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @discount1 = @merchant1.discounts.create!(name: "winter special", number_items: 2, percent: 5)
      
      @merchant2 = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @discount2 = @merchant2.discounts.create!(name: "big sale", number_items: 4, percent: 10)
      @discount3 = @merchant2.discounts.create!(name: "bigger sale", number_items: 6, percent: 15)

      @item1 = @merchant1.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 10)
      @item2 = @merchant1.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @item3 = @merchant2.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      visit "/items/#{@item1.id}"
      click_on "Add To Cart"
      visit "/items/#{@item2.id}"
      click_on "Add To Cart"
      visit "/items/#{@item3.id}"
      click_on "Add To Cart"

      visit "/cart"
      within("tr#cart-item-#{@item1.id}") do
        click_button("Add One More")
        click_button("Add One More")
      end

      within("tr#cart-item-#{@item3.id}") do
        click_button("Add One More")
        click_button("Add One More")
        click_button("Add One More")
        click_button("Add One More")
      end

      click_on "Checkout"
    end

    it "the order new page reflects the discounts applied to the items in the cart" do 

      within("tr#order-item-#{@item1.id}") do 
        within("td#order-item-price-#{@item1.id}") do 
          expect(page).to have_content(@item1.price*0.95)
        end
        within("td#order-item-subtotal-#{@item1.id}") do 
          expect(page).to have_content(@item1.price*0.95*3)
        end

      end

      within("tr#order-item-#{@item2.id}") do 
        within("td#order-item-price-#{@item2.id}") do 
          expect(page).to have_content(@item2.price*1)
        end
        within("td#order-item-subtotal-#{@item2.id}") do 
          expect(page).to have_content(@item2.price)
        end
      end

      within("tr#order-item-#{@item3.id}") do 
        within("td#order-item-price-#{@item3.id}") do 
          expect(page).to have_content(@item3.price*0.9)
        end
        within("td#order-item-subtotal-#{@item3.id}") do 
          expect(page).to have_content(@item3.price*0.9*5)
        end
      end

      expect(page).to have_content("Total: $#{(@item1.price*0.95*3)+(@item2.price)+(@item3.price*0.9*5)}")

    end

    it "my order, once created reflects the discounts applied to the items in the cart" do 

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      latest_order = Order.last

      click_button "Create Order"

      new_order = Order.last

      expect(new_order).to_not eq(latest_order)

      expect(new_order.grandtotal).to eq((@item1.price*0.95*3)+(@item2.price)+(@item3.price*0.9*5))
    end


  end

end