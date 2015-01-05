class Invoice < ActiveRecord::Base
  belongs_to :customer
  has_many :line_items, :inverse_of => :invoice
  has_many :products, :through => :line_items
  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates :tax_rate, numericality: {greater_than_or_equal_to: 0.0}
  validates :customer, :presence => true

  def sub_total
    sum = 0
    line_items.each do |line_item|
      sum += line_item.total
    end
    sum
  end

  def general_total
    t = sub_total
    t + (t * (tax_rate / 100))
  end
end
