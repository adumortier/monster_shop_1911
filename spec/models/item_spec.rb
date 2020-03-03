require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @default_user_1 = User.create!(name: 'Bert',
                                   street_address: '123 Sesame St.',
                                   city: 'NYC',
                                   state: 'New York',
                                   zip_code: "10001",
                                   email: 'roman@examples.com',
                                   password: 'cheeseburger02',
                                   role: 0)

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = @default_user_1.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "most and least popular items" do
      merchant = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      item_1 = merchant.items.create!(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      item_2 = merchant.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      item_3 = merchant.items.create!(name: 'Shimano Shifters', description: "It'll always shift!", price: 180, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 2)
      item_4 = merchant.items.create!(name: 'Boots', description: "Dont fear the rain!", price: 129, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 6)
      item_5 = merchant.items.create!(name: 'Bike Lights', description: "Dont fear the dark!", price: 62, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 10)
      item_6 = merchant.items.create!(name: 'Camelback water bottle', description: "Dont fear the thirst!", price: 42, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 10)
      item_7 = merchant.items.create!(name: 'Helmet', description: "Dont fear the risk!", price: 20, image: 'https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg', inventory: 15)

      merchant_user_1 = User.create!(name: 'Mark',
                                   street_address: '112 Elm St.',
                                   city: 'Cambridge',
                                   state: 'MA',
                                   zip_code: "92139",
                                   email: 'greek@examples.com',
                                   password: 'hamburger03',
                                   role: 1)

      order_1 = @default_user_1.orders.create!(name: 'Bert', address: '123 Sesame St.', city: 'NYC', state: 'New York', zip: 10001)
      order_2 = merchant_user_1.orders.create!(name: 'Mark', address: '112 Elm St.', city: 'Cambridge', state: 'MA', zip: 92139)

      item_order1_info = { order_id: order_1.id, item_id: item_1.id, price: item_1.price, quantity: 34 }
      ItemOrder.create!(item_order1_info)

      item_order2_info = { order_id: order_2.id, item_id: item_2.id, price: item_2.price, quantity: 20 }
      ItemOrder.create!(item_order2_info)

      item_order3_info = { order_id: order_1.id, item_id: item_3.id, price: item_3.price, quantity: 100 }
      ItemOrder.create!(item_order3_info)

      item_order4_info = { order_id: order_2.id, item_id: item_4.id, price: item_4.price, quantity: 27 }
      ItemOrder.create!(item_order4_info)

      item_order5_info = { order_id: order_1.id, item_id: item_5.id, price: item_5.price, quantity: 56 }
      ItemOrder.create!(item_order5_info)

      item_order6_info = { order_id: order_2.id, item_id: item_6.id, price: item_6.price, quantity: 23 }
      ItemOrder.create!(item_order6_info)

      item_order7_info = {order_id: order_1.id, item_id: item_7.id, price: item_7.price, quantity: 54 }
      ItemOrder.create!(item_order7_info)

      item_order8_info = {order_id: order_2.id, item_id: item_1.id, price: item_1.price, quantity: 35 }
      ItemOrder.create!(item_order8_info)

      expect([Item.most_popular_items[0].name, Item.most_popular_items[1].name, Item.most_popular_items[2].name, Item.most_popular_items[3].name, Item.most_popular_items[4].name]).to eq([item_3.name, item_1.name, item_5.name, item_7.name, item_4.name])

      expect([Item.least_popular_items[0].name, Item.least_popular_items[1].name, Item.least_popular_items[2].name, Item.least_popular_items[3].name, Item.least_popular_items[4].name]).to eq([item_2.name, item_6.name, item_4.name, item_7.name, item_5.name])

    end

    it "can find which quantities apply to a bulk discount" do 

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 5)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 3)
      @pen = @mike.items.create(name: "Red Pen", description: "You can write on paper with it!", price: 1, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)

      @discount1 = @mike.discounts.create!(name: "winter sale", percent: 15.0, number_items: 10)
      @discount2 = @mike.discounts.create!(name: "super winter sale", percent: 20.0, number_items: 15)

      expect(@paper.check_discount(4)).to eq(["no discount applied", 0])
      expect(@paper.check_discount(9)).to eq(["no discount applied", 0])
      expect(@paper.check_discount(10)).to eq(["winter sale", 15.0])
      expect(@paper.check_discount(14)).to eq(["winter sale", 15.0])
      expect(@paper.check_discount(15)).to eq(["super winter sale", 20.0])
      expect(@paper.check_discount(16)).to eq(["super winter sale", 20.0])
    end

    it "can calculate the unit price of an item with a discount if one applies" do 
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 5)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 3)
      @pen = @mike.items.create(name: "Red Pen", description: "You can write on paper with it!", price: 1, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)

      @discount1 = @mike.discounts.create!(name: "winter sale", percent: 15.0, number_items: 10)
      @discount2 = @mike.discounts.create!(name: "super winter sale", percent: 20.0, number_items: 15)

      expect(@paper.unit_price(4)).to eq(@paper.price)
      expect(@paper.unit_price(9)).to eq(@paper.price)
      expect(@paper.unit_price(10)).to eq(@paper.price*0.85)
      expect(@paper.unit_price(14)).to eq(@paper.price*0.85)
      expect(@paper.unit_price(15)).to eq(@paper.price*0.80)
      expect(@paper.unit_price(16)).to eq(@paper.price*0.80)
    end
  end
end
