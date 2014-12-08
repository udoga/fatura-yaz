require 'minitest/autorun'
require_relative '../lib/invoice_writer'
require_relative '../lib/invoice_config'
require_relative '../lib/config_validator'

class TestInvoiceWriter < MiniTest::Test
  def setup
    @validator = ConfigValidator.new
    @config = InvoiceConfig.from_file('../lib/config/digits.yml')
    @validator.validate_config @config
    @invoice_writer = InvoiceWriter.new(@config)
    @invoice_data = get_invoice_data
  end

  def test_generate_invoice
    @invoice_writer.generate @invoice_data
  end

  private
  def get_invoice_data
    {'date' => '01/01/2014',
     'time' => '17:00',
     'buyer-name' => 'ABCD Yazılım ve Dan. Tic. Ltd. Şti.',
     'buyer-address' => "\nİnkılap Mah. Küçüksu Cad. No:111/1\n34768         Ümraniye / İstanbul",
     'buyer-tax_office' => 'ÜMRANİYE',
     'buyer-tax_office_no' => '7360000000',
     'line_items' =>
         {'description' => ["Teknik Hizmet Bedeli\n  ( 000 TL / Gün )", 'Deneme'],
          'quantity' => %w(20 30),
          'unit' => %w(gün gün),
          'unit_price' => %w(000.00 000.00),
          'line_total' => %w(00,000.00 00,000.00)},
     'total' => '00,000.00',
     'tax_rate' => '00',
     'tax_amount' => '0,000.00',
     'general_total' => '00,000.00',
     'general_total_reading' => 'SIFIR TL.'
    }
  end
end
