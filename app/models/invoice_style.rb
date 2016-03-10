require_relative "#{Rails.root}/core/invoice-printer/lib/invoice_config"
require_relative "#{Rails.root}/core/invoice-printer/lib/config_validator"

class InvoiceStyle < ActiveRecord::Base
  has_many :invoices

  validates :name, presence: true
  validates :style_content, presence: true
  validate :validate_style_content

  @@validator = ConfigValidator.new

  def validate_style_content
    begin
      @@validator.validate_config(get_config())
    rescue ConfigValidator::InvalidConfig => e
      error_message = ("errors:\n" + e.to_s).gsub("\n", "<br/>").html_safe
      errors.add(:style_content, error_message)
    end
  end

  def get_config
    return InvoiceConfig.from_text(style_content)
  end
end
