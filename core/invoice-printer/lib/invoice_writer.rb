require_relative 'page_writer'

class InvoiceWriter
  def generate(invoice_data, config)
    @config = config
    make_page_writer_settings
    write_invoice_data invoice_data
    write_addenda_contents
    @writer.render_file('../output.pdf')
  end

  private
  def make_page_writer_settings
    page_size = @config.page_size
    page_size = page_size.map {|i| mm_to_pt(i)} if page_size.is_a? Array
    @writer = PageWriter.new(margin: 0, page_size: page_size)
    @writer.font '../fonts/' + @config.font + '.ttf'
    @writer.font_size @config.font_size
    @writer.default_leading @config.default_leading
  end

  def write_invoice_data(invoice_data)
    invoice_data.each do |field_name, data|
      if data.is_a? Hash
        write_table field_name, data
      elsif data.is_a? String
        options = @config.page_item(field_name)
        @writer.write data, convert_millimeters_to_points(options) unless options.empty?
      end
    end
  end

  def write_table(table_name, invoice_table_data)
    table_data = []
    field_options = []
    invoice_table_data.each do |field, values|
      options = @config.page_item(table_name + '.' + field)
      unless options.empty?
        field_options << convert_millimeters_to_points(options)
        table_data << values
      end
    end
    table_data = table_data.transpose
    table_options = convert_millimeters_to_points(@config.table(table_name))
    @writer.write_table_data table_data, field_options, table_options
  end

  def write_addenda_contents
    @config.get_addenda_contents.each do |content|
      options = @config.addenda(content)
      @writer.write content, convert_millimeters_to_points(options) unless options.empty?
    end
  end

  def convert_millimeters_to_points(options)
    options = options.clone
    options.each do |key, value|
      if [:left, :center, :right].include? key
        options[key] = value.map {|i| mm_to_pt(i)}
      elsif [:width, :height, :row_space].include? key
        options[key] = mm_to_pt(value)
      end
    end
    options
  end

  def mm_to_pt(mm)
    mm * 2.8346
  end
end
