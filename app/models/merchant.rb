class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :discounts
  has_many :orders, through: :item_orders
  enum status: %w(enabled disabled)


  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def deactivate_items
    items.each do |item|
      if item.active? == true
        item.update(active?: false)
      end
    end
  end

  def activate_items
    items.each do |item|
      if item.active? == false
        item.update(active?: true)
      end
    end
  end

  def distinct_orders
    orders.distinct
  end

  def change_status
    if enabled?
      self.update(status: 1)
      deactivate_items
    else
      self.update(status: 0)
      activate_items
    end
  end

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    (item_orders.distinct.joins(:order).pluck(:city)).sort
  end

  def item_ordered?(item)
    !item_orders.where("item_id = #{item.id}").empty?
  end
end
