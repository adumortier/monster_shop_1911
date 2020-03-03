require 'rails_helper'

describe Cart, type: :model do
  describe 'instance methods' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 5)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 3)
      @pen = @mike.items.create(name: "Red Pen", description: "You can write on paper with it!", price: 1, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)
      @cart = Cart.new({"#{@paper.id.to_s}" => 4, "#{@pencil.id.to_s}" => 2, "#{@pen.id.to_s}" => 2})

      @discount1 = @mike.discounts.create!(name: "cool discount", percent: 15.0, number_items: 10)
      @discount2 = @mike.discounts.create!(name: "cooler discount", percent: 20.0, number_items: 15)
    end

    it "can add one to quantity of an item" do
      expect(@cart.contents[@paper.id.to_s]).to eq(4)
      @cart.add_quantity(@paper.id.to_s)
      expect(@cart.contents[@paper.id.to_s]).to eq(5)

      expect(@cart.contents[@pencil.id.to_s]).to eq(2)
      @cart.add_quantity(@pencil.id.to_s)
      expect(@cart.contents[@pencil.id.to_s]).to eq(3)
    end

    it "can subtract one from quantity of an item" do
      expect(@cart.contents[@paper.id.to_s]).to eq(4)
      @cart.subtract_quantity(@paper.id.to_s)
      expect(@cart.contents[@paper.id.to_s]).to eq(3)

      expect(@cart.contents[@pencil.id.to_s]).to eq(2)
      @cart.subtract_quantity(@pencil.id.to_s)
      expect(@cart.contents[@pencil.id.to_s]).to eq(1)
    end

    it "can check to see if the quantity of an item is not equal to zero" do
      expect(@cart.contents[@pencil.id.to_s]).to eq(2)
      @cart.subtract_quantity(@pencil.id.to_s)
      expect(@cart.quantity_zero?(@pencil.id.to_s)).to eq(false)

      @cart.contents[@pencil.id.to_s] = 0
      expect(@cart.quantity_zero?(@pencil.id.to_s)).to eq(true)
    end

    it "can check to see if items in cart equal inventory total for an item" do
      expect(@cart.contents[@paper.id.to_s]).to eq(4)
      @cart.add_quantity(@paper.id.to_s)
      expect(@cart.contents[@paper.id.to_s]).to eq(5)
      expect(@cart.limit_reached?(@paper.id.to_s)).to eq(true)
    end

  end
end
