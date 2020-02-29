class Discount < ApplicationRecord

  validates_presence_of :name, :number_items, :percent

  belongs_to :merchant

end