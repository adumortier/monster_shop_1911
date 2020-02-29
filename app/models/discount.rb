class Discount < ApplicationRecord

  validates_presence_of :name, :number_items, :percent

  validates_numericality_of :number_items, greater_than: 0, message: " must be greater than 0"
  validates_numericality_of :percent, greater_than: 0, message: " must be greater than 0"

  belongs_to :merchant

  def valid_discount?
    merchant.discounts.order(:number_items) == merchant.discounts.order(:percent)  
  end

end