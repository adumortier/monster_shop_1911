# frozen_string_literal: true

class Order < ApplicationRecord
  
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user

  enum status: %w[pending packaged shipped cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    items.sum(:quantity)
  end

  def item_quantity_merchant(merchant)
    items.where(merchant: merchant).sum('item_orders.quantity')
  end

  def item_total_merchant(merchant)
    items.where(merchant: merchant).sum("item_orders.quantity * item_orders.price")
  end

  def status_changer
    if item_orders.all? { |itemorder| itemorder.status == 'fulfilled' }
      update(status: 'packaged')
    end
  end

  def self.pending_status
    all.where(status: "pending")
  end

  def self.packaged_status
    all.where(status: "packaged")
  end

  def self.shipped_status
    all.where(status: "shipped")
  end

  def self.cancelled_status
    self.all.where(status: "cancelled")
  end
end
