class LineItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :product
  validates :invoice, :presence => true
  validates :product, :presence => true
  validates :quantity, numericality: {greater_than_or_equal_to: 1}

  def total
    quantity * product.unit_price.to_f
  end
end
