require 'rails_helper'

RSpec.describe "Merchant order show page", type: :feature do
  before(:each) do
    @merchant = create(:random_merchant)
    @merchant_2 = create(:random_merchant)


    @item_1 = @merchant.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @item_2 = create(:random_item, merchant_id: @merchant.id, inventory: 3)
    @item_3 = create(:random_item, merchant_id: @merchant.id, inventory: 3)
    @item_4 = create(:random_item, merchant_id: @merchant.id, inventory: 2)
    @item_5 = create(:random_item, merchant_id: @merchant.id, inventory: 3)
    @item_6 = create(:random_item, merchant_id: @merchant_2.id, inventory: 3)
    @item_7 = create(:random_item, merchant_id: @merchant_2.id, inventory: 3)
    @item_8 = @merchant.items.create(name: "Caramel", description: "It'll break your teeth!", price: 5, image: "https://www.theflavorbender.com/wp-content/uploads/2019/11/Salted-Caramel-Sauce-Social-Media-5252.jpg", inventory: 2)

    @bill = @merchant.users.create(name: "Billy",
                                   street_address: "123 Bilbo Baggins Ave",
                                   city: "Rockville",
                                   state: "TN",
                                   zip_code: 34566,
                                   email: "billybob@example.com",
                                   password: "MynameisBill3",
                                   role: 1
                                   )

    @user = create(:random_user, role: 0)
    @user2 = create(:random_user, role: 0)
  end
    it "I see order user attributes and items from my store in the order" do

    visit '/login'

    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password

    click_on 'Log In'

    click_on("All Items")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_2.name)
    click_on("Add To Cart")

    click_on(@item_3.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
    click_on("Add To Cart")

    click_on(@item_5.name)
    click_on("Add To Cart")

    click_on(@item_6.name)
    click_on("Add To Cart")

    click_on(@item_7.name)
    click_on("Add To Cart")

    click_on(@item_8.name)
    click_on("Add To Cart")

    click_on(@item_8.name)
    click_on("Add To Cart")

    within 'nav' do 
      click_on("Cart")
    end

    click_on("Checkout")

    fill_in 'name', with: @user.name
    fill_in 'address', with: @user.street_address
    fill_in 'city', with: @user.city
    fill_in 'state', with: @user.state
    fill_in 'zip', with: @user.zip_code

    click_on("Create Order")

    click_on("Log Out")

    click_on("Login")

    fill_in 'email', with: @bill.email
    fill_in 'password', with: @bill.password

    click_on 'Log In'

    order = Order.last

    expect(current_path).to eq('/merchant')

    click_on(order.id)

    expect(current_path).to eq("/merchant/orders/#{order.id}")

    expect(page).to have_content(order.name)
    expect(page).to have_content(order.address)
    expect(page).to have_content(order.city)
    expect(page).to have_content(order.state)
    expect(page).to have_content(order.zip)

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content("Number of Items: 2")
      expect(page).to have_button("Fulfill")
      expect(@item_1.inventory).to eq(5)
      click_on("Fulfill")
    end

    @item_1.reload
    expect(@item_1.inventory).to eq(3)

    expect(current_path).to eq("/merchant/orders/#{order.id}")

    expect(page).to have_content("#{@item_1.name} has been fulfilled!")

    within "#item-#{@item_1.id}" do
      expect(page).to have_content("Fulfilled")
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_css("img[src*='#{@item_2.image}']")
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content("Number of Items: 1")
      expect(page).to have_button("Fulfill")
    end

    within "#item-#{@item_3.id}" do
      expect(page).to have_content(@item_3.name)
      expect(page).to have_css("img[src*='#{@item_3.image}']")
      expect(page).to have_content(@item_3.price)
      expect(page).to have_content("Number of Items: 1")
      expect(page).to have_button("Fulfill")
    end

    within "#item-#{@item_4.id}" do
      expect(page).to have_content(@item_4.name)
      expect(page).to have_css("img[src*='#{@item_4.image}']")
      expect(page).to have_content(@item_4.price)
      expect(page).to have_content("Number of Items: 2")
      expect(page).to have_button("Fulfill")
    end

    within "#item-#{@item_5.id}" do
      expect(page).to have_content(@item_5.name)
      expect(page).to have_css("img[src*='#{@item_5.image}']")
      expect(page).to have_content(@item_5.price)
      expect(page).to have_content("Number of Items: 1")
      expect(page).to have_button("Fulfill")
    end

    expect(page).to_not have_content(@item_6.name)
    expect(page).to_not have_content(@item_7.name)

    within "#item-#{@item_1.id}" do
      expect(page).to have_content("This item is fulfilled.")
    end

    within "#item-#{@item_8.id}" do
      expect(page).to have_content(@item_8.name)
      expect(page).to have_css("img[src*='#{@item_8.image}']")
      expect(page).to have_content(@item_8.price)
      expect(page).to have_content("Number of Items: 2")
      expect(page).to have_button("Fulfill")
      expect(page).to_not have_content("Can not fulfill this item")
    end
  end
  it "can not fulfill an item on order that has to much desired quantity" do

    visit '/login'

    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password

    click_on 'Log In'

    click_on("All Items")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_1.name)
    click_on("Add To Cart")

    click_on(@item_2.name)
    click_on("Add To Cart")

    click_on(@item_3.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
    click_on("Add To Cart")

    click_on(@item_5.name)
    click_on("Add To Cart")

    click_on(@item_6.name)
    click_on("Add To Cart")

    click_on(@item_7.name)
    click_on("Add To Cart")

    click_on(@item_8.name)
    click_on("Add To Cart")

    click_on(@item_8.name)
    click_on("Add To Cart")

    within 'nav' do 
      click_on("Cart")
    end

    click_on("Checkout")

    fill_in 'name', with: @user.name
    fill_in 'address', with: @user.street_address
    fill_in 'city', with: @user.city
    fill_in 'state', with: @user.state
    fill_in 'zip', with: @user.zip_code

    click_on("Create Order")

    click_on("Log Out")

    click_on("Login")

    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password

    click_on 'Log In'

    click_on("All Items")

    click_on(@item_4.name)
    click_on("Add To Cart")

    click_on(@item_4.name)
    click_on("Add To Cart")

    within 'nav' do 
      click_on("Cart")
    end

    click_on("Checkout")

    fill_in 'name', with: @user.name
    fill_in 'address', with: @user.street_address
    fill_in 'city', with: @user.city
    fill_in 'state', with: @user.state
    fill_in 'zip', with: @user.zip_code

    click_on("Create Order")

    click_on("Log Out")

    click_on("Login")

    fill_in 'email', with: @bill.email
    fill_in 'password', with: @bill.password

    click_on 'Log In'

    order = Order.first
    order2 = Order.last

    expect(current_path).to eq('/merchant')

    click_on(order.id)

    within "#item-#{@item_4.id}" do
      expect(page).to have_content(@item_4.name)
      expect(page).to have_css("img[src*='#{@item_4.image}']")
      expect(page).to have_content(@item_4.price)
      expect(page).to have_content("Number of Items: 2")
      expect(page).to have_button("Fulfill")
      click_on("Fulfill")
    end

    click_on("Log Out")

    click_on 'Login'

    fill_in 'email', with: @bill.email
    fill_in 'password', with: @bill.password

    click_on 'Log In'

    expect(current_path).to eq('/merchant')

    click_on(order2.id)

    within "#item-#{@item_4.id}" do
      expect(page).to have_content(@item_4.name)
      expect(page).to have_css("img[src*='#{@item_4.image}']")
      expect(page).to have_content(@item_4.price)
      expect(page).to have_content("Number of Items: 2")
      expect(page).to_not have_button("Fulfill")
    end
  end
end
