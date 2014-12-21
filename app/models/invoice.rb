class Invoice < ActiveRecord::Base
  belongs_to :customer
  validates :tax_rate, numericality: {greater_than_or_equal_to: 0.0}
end
