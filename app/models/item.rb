class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_presence_of :image, :allow_blank => true

  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0, message: " must be greater than 0"
  validates_numericality_of :inventory, greater_than_or_equal_to: 0, message: " must be greater than or equal to 0"

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_popular_items
    joins(:item_orders).select("items.*, sum(item_orders.quantity) as qty").group("items.id").order("qty desc").limit(5)
  end

  def self.least_popular_items
     joins(:item_orders).select("items.*, sum(item_orders.quantity) as qty").group("items.id").order("qty asc").limit(5)
  end

  def switch_active_status
    toggle!(:active?)
  end

  def check_discount(quantity)
    if merchant.discounts.where("number_items <= #{quantity}").blank?
      ["no discount applied", 0]
    else
      merchant.discounts.select("name, percent")
      .where("number_items < #{quantity} OR number_items = #{quantity}")
      .order(number_items: :desc)
      .limit(1)
      .pluck(:name, :percent)
      .first
    end
  end

  def unit_price(quantity)
    if merchant.discounts.select("percent").where("number_items < #{quantity} OR number_items = #{quantity}").order(number_items: :desc).limit(1).pluck(:percent).first.nil?
      price
    else
      price * (1 - 0.01*merchant.discounts.select("percent").where("number_items < #{quantity} OR number_items = #{quantity}").order(number_items: :desc).limit(1).pluck(:percent).first)
    end
  end

end
