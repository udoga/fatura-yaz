require_relative 'page_writer'

class InvoiceWriter
  def initialize(config)
    @config = config
    @writer = PageWriter.new(margin: 0, page_size: @config.page_size)
    @writer.font '../fonts/' + @config.font + '.ttf'
    @writer.font_size @config.font_size
    @writer.default_leading @config.default_leading
  end

  def generate(invoice_data)
    write_invoice_data invoice_data
    write_addenda_contents
    @writer.render_file('../output.pdf')
  end

  private
  def write_invoice_data(invoice_data)
    invoice_data.keys.select{|k| k != 'line_items'}.each do |field_name|
      options = @config.page_item(field_name)
      @writer.write invoice_data[field_name], convert_millimeters_to_points(options) if options
    end
    write_line_items invoice_data['line_items']
  end

  def write_line_items(line_items)
    line_items.each do |line_item|
      line_item.keys.each do |field|
        options = @config.page_item("line_items.#{field}")
        @writer.write line_item[field], convert_millimeters_to_points(options) if options
      end
    end
    # line_items = [
    #     ["Teknik Hizmet Bedeli\n  ( 000 TL / Gün )", '20', 'gün', '000.00', '00,000.00'],
    #     ['Deneme', '30', 'gün', '000.00', '00,000.00']]
    # field_options = [{:left => [80, 499], :width => 219},
    #                  {:center => [317, 499], :width => 36},
    #                  {:center => [346, 499], :width => 22},
    #                  {:right => [421, 499], :width => 63},
    #                  {:right => [529, 499], :width => 108}]
    # table_options = {:row_space => 14}
    # @writer.write_table_data line_items, field_options, table_options
  end

  def write_addenda_contents
    @config.get_addenda_contents.each do |content|
      options = @config.addenda(content)
      @writer.write content, convert_millimeters_to_points(options) if options
    end
  end

  def convert_millimeters_to_points(options)
    options = options.clone
    options.each do |key, value|
      if [:left, :center, :right].include? key
        options[key] = value.map {|i| mm_to_pt(i)}
      elsif [:width, :height].include? key
        options[key] = mm_to_pt(value)
      end
    end
    options
  end

  def mm_to_pt(mm)
    mm * 2.8346
  end
end
