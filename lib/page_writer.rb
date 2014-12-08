require 'prawn'
require 'pdf/core'

class PageWriter < Prawn::Document
  PAGE_SIZES = PDF::Core::PageGeometry::SIZES
  attr_reader :page_dimensions

  def initialize(options)
    @page_dimensions = options[:page_size]
    @page_dimensions = PAGE_SIZES[@page_dimensions] if @page_dimensions.is_a? String
    super options
  end

  def write(text, options)
    options = convert_options(options, text)
    text_box text, options
  end

  def write_table_data(table_data, first_row_options, table_options)
    row_space = table_options[:row_space] || 0
    last_row_options = first_row_options.clone
    table_data.each do |row_data|
      max_line_count_in_row = 1
      for i in 0..(row_data.size-1)
        write row_data[i], last_row_options[i]
        line_count_in_cell = calculate_line_count
        max_line_count_in_row = line_count_in_cell if line_count_in_cell > max_line_count_in_row
      end
      row_height = (max_line_count_in_row * get_line_height) + row_space
      last_row_options.each do |item_options|
        item_options[get_position_key(item_options)][1] -= row_height
      end
    end
  end

  def convert_options(options, text)
    @text = text
    @options = options.clone
    @position_key = get_position_key(@options)
    @text_width = width_of @text
    @wrap_width = calculate_wrap_width
    @width = @options[:width]
    if @width
      @options[:align] = @position_key
    elsif @text_width <= @wrap_width or @options[:single_line]
      @width = @text_width
    else
      @width = calculate_width
      @options[:width] = @width
      @options[:align] = @position_key
    end
    convert_position_key
    @options
  end

  private
  def get_position_key(options)
    options.keys.each do |attribute|
      return attribute if [:left, :center, :right].include? attribute
    end
  end

  def convert_position_key
    shift_amount = {:left => 0, :center => @width/2, :right => @width}[@position_key]
    position = @options.delete(@position_key).clone
    position[0] -= shift_amount
    @options[:at] = position
  end

  def calculate_wrap_width
    page_width = @page_dimensions[0]
    left_amount = @options[@position_key][0]
    right_amount = page_width - left_amount
    {:left => right_amount, :center => [left_amount, right_amount].min, :right => left_amount}[@position_key]
  end

  def calculate_width
    return 2*@wrap_width if @position_key == :center
    @wrap_width
  end

  def get_line_height
    height_of('sample')
  end

  def calculate_line_count
    return 1 if @text.empty?
    line_count = 0
    @text.split("\n", -1).each do |part|
      line_count += (part.empty?)? 1 : (width_of(part) / @width).ceil
    end
    line_count
  end
end