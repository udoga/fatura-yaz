class InvoiceStyle < ActiveRecord::Base
  has_many :invoices

  validates :name, presence: true
  validates :style_content, presence: true
end
