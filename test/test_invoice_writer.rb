require 'minitest/autorun'
require_relative '../lib/invoice_writer'
require_relative '../lib/invoice_config'

class TestInvoiceWriter < MiniTest::Test
  def setup
    @config = InvoiceConfig.from_file('../lib/config/digits.yml')
    @invoice_writer = InvoiceWriter.new(@config)
    @invoice_data = :invoice_data
  end
end