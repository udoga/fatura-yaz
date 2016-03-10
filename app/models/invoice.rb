require_relative "#{Rails.root}/core/invoice-printer/lib/invoice_writer"

class Invoice < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :customer
  has_many :line_items, :inverse_of => :invoice
  has_many :products, :through => :line_items
  belongs_to :invoice_style
  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates :tax_rate, numericality: {greater_than_or_equal_to: 0.0}
  validates :customer, :presence => true

  @@invoice_writer = InvoiceWriter.new

  def sub_total
    sum = 0
    line_items.each do |line_item|
      sum += line_item.total
    end
    return sum.round(2)
  end

  def tax_amount
    return (sub_total * (tax_rate / 100)).round(2)
  end

  def general_total
    return (sub_total + tax_amount).round(2)
  end

  def get_data_in_hash_format
      return {
        'date' => date.strftime("%m/%d/%Y"),
        'time' => time.strftime("%H:%M"),
        'buyer-name' => customer.name,
        'buyer-address' => customer.address,
        'buyer-tax_office' => customer.tax_office,
        'buyer-tax_office_no' => customer.tax_office_no,
        'line_items' =>
           {'description' => line_items.map {|l| l.product.description},
            'quantity' => line_items.map {|l| l.quantity.to_s},
            'unit' => line_items.map {|l| l.product.unit},
            'unit_price' => line_items.map {|l| format_price(l.product.unit_price)},
            'line_total' => line_items.map {|l| format_price(l.total)}},
        'total' => format_price(sub_total),
        'tax_rate' => format_price(tax_rate),
        'tax_amount' => format_price(tax_amount),
        'general_total' => format_price(general_total),
        'general_total_reading' => get_price_reading(general_total)
      }
  end

  def print_pdf(output_file_location)
    @@invoice_writer.generate(get_data_in_hash_format(), invoice_style.get_config(), output_file_location)
  end
end
