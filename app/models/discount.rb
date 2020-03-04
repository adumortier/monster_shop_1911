class Discount < ApplicationRecord

  validates_presence_of :name, :number_items, :percent

  validates_numericality_of :number_items, greater_than: 0, message: " must be greater than 0"
  validates_numericality_of :percent, greater_than: 0, message: " must be greater than 0"

  belongs_to :merchant

  def valid_discount?
    merchant.discounts.order(:number_items) == merchant.discounts.order(:percent)  
  end

  def unique_discount?
    merchant.discounts.select(:name).distinct.count == merchant.discounts.count  && 
    merchant.discounts.select(:number_items).distinct.count == merchant.discounts.count &&
    merchant.discounts.select(:percent).distinct.count == merchant.discounts.count 
  end

end