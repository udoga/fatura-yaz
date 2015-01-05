class Product < ActiveRecord::Base
  has_many :line_items
  has_many :invoices, :through => :line_items
  validates :description, :unit, presence: true
  validates :unit_price, numericality: {greater_than_or_equal_to: 0.0}
end
