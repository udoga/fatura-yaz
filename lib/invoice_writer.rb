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
    @writer.draw_text '25/08/2014', @config.page_item('date')
    @writer.draw_text '17:00', @config.page_item('time')
    @writer.draw_text 'ABCD Yazılım ve Dan. Tic. Ltd. Şti.', @config.page_item('buyer-name')
    @writer.text_box "\nİnkılap Mah. Küçüksu Cad. No:111/1" +
                     "\n34768         Ümraniye / İstanbul", @config.page_item('buyer-address')
    @writer.draw_text 'ÜMRANİYE', @config.page_item('buyer-tax_office')
    @writer.draw_text '7360000000', @config.page_item('buyer-tax_office_no')

    @writer.render_file('../output.pdf')
  end
end
