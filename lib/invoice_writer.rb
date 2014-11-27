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
    write_invoice_data invoice_data
    write_addenda_contents
    @writer.render_file('../output.pdf')
  end

  def write_invoice_data(invoice_data)
    invoice_data.keys.each do |field_name|
      if field_name == 'line_items'
        write_line_items(invoice_data[field_name])
      else
        @writer.write invoice_data[field_name], @config.page_item(field_name)
      end
    end
  end

  def write_line_items(line_items)
    line_items.each do |line_item|
      line_item.keys.each do |field|
        @writer.write line_item[field], @config.page_item("line_items.#{field}")
      end
    end
  end

  def write_addenda_contents
    @config.get_addenda_contents.each do |content|
      @writer.write content, @config.addenda(content)
    end
  end
end
