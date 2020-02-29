require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
    it {should have_many(:orders).through(:item_orders)}
    it {should have_many :discounts}
  end

  describe 'instance methods' do
    before(:each) do
      @merchant_user_1 = User.create!(name: 'Meg',
                                   street_address: '123 Stang Ave',
                                   city: 'Hershey',
                                   state: 'PA',
                                   zip_code: 17033,
                                   email: 'roman@example.com',
                                   password: 'hamburger01',
                                   role: 1)
      @merchant_user_2 = User.create!(name: 'Brian',
                                   street_address: '123 Brian Ave',
                                   city: 'Denver',
                                   state: 'CO',
                                   zip_code: 17033,
                                   email: 'roman@examples.com',
                                   password: 'hamburger02',
                                   role: 1)
      @merchant_user_3 = User.create!(name: 'Dao',
                                   street_address: '123 Mike Ave',
                                   city: 'Denver',
                                   state: 'CO',
                                   zip_code: 17033,
                                   email: 'roman@exampless.com',
                                   password: 'hamburger03',
                                   role: 1)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @merchant_user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      order_1 = @merchant_user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = @merchant_user_2.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_3 = @merchant_user_3.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to eq(["Denver","Hershey"])
    end

    it 'change_status' do
      merchant = create(:random_merchant)
      merchant_2 = create(:random_merchant, status: 1)

      expect(merchant.enabled?).to be_truthy

      merchant.change_status

      expect(merchant.disabled?).to be_truthy

      expect(merchant_2.disabled?).to be_truthy

      merchant_2.change_status

      expect(merchant_2.enabled?).to be_truthy
    end
    it 'deactivates items' do
      merchant = create(:random_merchant)
      item = create(:random_item, merchant_id: merchant.id)
      item2 = create(:random_item, merchant_id: merchant.id, active?: false)

      merchant.deactivate_items

      item.reload
      item2.reload

      expect(item.active?).to eq(false)
      expect(item2.active?).to eq(false)
    end
    it 'activates items' do
      merchant = create(:random_merchant)
      item = create(:random_item, merchant_id: merchant.id)
      item2 = create(:random_item, merchant_id: merchant.id, active?: false)

      merchant.activate_items

      item.reload
      item2.reload

      expect(item.active?).to eq(true)
      expect(item2.active?).to eq(true)
    end

    it '#item_ordered?' do
      user = create(:random_user, role: 0)
      order = create(:random_order, user: user)

      ItemOrder.create!(item: @chain, order: order, price: @chain.price, quantity: 5)
      expect(@meg.item_ordered?(@chain)).to eq(true)
      expect(@meg.item_ordered?(@tire)).to eq(false)
    end

    it 'distinct_orders' do
      user = create(:random_user, role: 0)

      order = create(:random_order, user: user)
      order.items.new(@tire.attributes)
      order.items.new(@chain.attributes)
      order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order.item_orders.create!(item: @chain, price: @chain.price, quantity: 3)

      order2 = create(:random_order, user: user)
      order2.items.new(@tire.attributes)
      order2.items.new(@chain.attributes)
      order2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)
      order2.item_orders.create!(item: @chain, price: @chain.price, quantity: 4)

      order3 = create(:random_order, user: user)
      order3.items.new(@tire.attributes)
      order3.items.new(@chain.attributes)
      order3.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)
      order3.item_orders.create!(item: @chain, price: @chain.price, quantity: 5)

      order4 = create(:random_order, user: user)
      order4.items.new(@tire.attributes)
      order4.items.new(@chain.attributes)
      order4.item_orders.create!(item: @tire, price: @tire.price, quantity: 14)
      order4.item_orders.create!(item: @chain, price: @chain.price, quantity: 3)

      order.reload
      order2.reload
      order3.reload
      order4.reload

      expect(@meg.distinct_orders.count).to eq(4)
    end
  end
end
