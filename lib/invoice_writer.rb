require_relative 'page_writer'

class InvoiceWriter
  def initialize(config)
    @config = config
    @writer = PageWriter.new(margin: 0, page_size: @config.page_size)
    @writer.font @config.font
    @writer.font_size @config.font_size
    @writer.default_leading @config.default_leading
  end

  def generate(invoice_data)
    @writer.write '25/08/2014', @config.page_item('date')
    @writer.write '17:00', @config.page_item('time')
    @writer.write 'ABCD Yazılım ve Dan. Tic. Ltd. Şti.', @config.page_item('buyer-name')
    @writer.write "\nİnkılap Mah. Küçüksu Cad. No:111/1" +
                  "\n34768         Ümraniye / İstanbul", @config.page_item('buyer-address')
    @writer.write 'ÜMRANİYE', @config.page_item('buyer-tax_office')
    @writer.write '7360000000', @config.page_item('buyer-tax_office_no')

    @writer.write "Teknik Hizmet Bedeli\n  ( 000 TL / Gün )", @config.page_item('line_items.description')
    @writer.write '20', @config.page_item('line_items.quantity')
    @writer.write 'Gün', @config.page_item('line_items.unit')
    @writer.write '000.00', @config.page_item('line_items.unit_price')
    @writer.write '00,000.00', @config.page_item('line_items.line_total')

    @writer.write '00,000.00', @config.page_item('total')
    @writer.write '00', @config.page_item('tax_rate')
    @writer.write '0,000.00', @config.page_item('tax_amount')
    @writer.write '00,000.00', @config.page_item('general_total')
    @writer.write 'SIFIR TL.', @config.page_item('general_total_reading')

    @config.get_addenda_contents.each do |content|
      @writer.write content, @config.addenda(content)
    end

    @writer.render_file('../output.pdf')
  end
end
