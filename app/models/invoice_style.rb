class InvoiceStyle < ActiveRecord::Base
  validates :name, presence: true
  validates :style_content, presence: true
end
