require 'minitest/autorun'
require_relative '../lib/invoice_writer'
require_relative '../lib/invoice_config'

class TestInvoiceWriter < MiniTest::Test
  def setup
    @config = InvoiceConfig.from_file('../lib/config/digits.yml')
    @invoice_writer = InvoiceWriter.new(@config)
    @invoice_data = :invoice_data
  end

  # def test_creates_pdf
  #   @invoice_writer.generate(@invoice_data)
  #   assert File.exist?('../output.pdf')
  # end
end