class Product < ActiveRecord::Base
  validates :description, :unit, presence: true
  validates :unit_price, numericality: {greater_than_or_equal_to: 0.0}
end
