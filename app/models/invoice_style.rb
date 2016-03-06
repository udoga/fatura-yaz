class InvoiceStyle < ActiveRecord::Base
  mount_uploader :style_file, InvoiceStyleUploader
  validates :name, presence: true
end
