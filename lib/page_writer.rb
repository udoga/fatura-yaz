require 'prawn'
require 'pdf/core'

class PageWriter < Prawn::Document
  attr_reader :page_dimensions

  def initialize(options)
    @page_dimensions = get_page_dimensions(options[:page_size])
    super options
  end

  def write(text, options)
    options = convert_options(options, text)
    text_box text, options
  end

  def convert_options(options, text)
    @text = text
    @options = options
    @position_key = get_position_key
    @text_width = width_of text
    @wrap_width = calculate_wrap_width
    @width = @options[:width]
    if @width
      @options[:align] = @position_key
    elsif @text_width <= @wrap_width or @options[:single_line]
      @width = @text_width
    else
      @width = calculate_width
      options[:width] = @width
      options[:align] = @position_key
    end
    convert_position_key
    @options
  end

  def get_position_key
    @options.keys.each do |attribute|
      return attribute if [:left, :center, :right].include? attribute
    end
  end

  def convert_position_key
    shift_amount = {:left => 0, :center => @width/2, :right => @width}[@position_key]
    position = @options.delete(@position_key)
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

  def get_page_dimensions(page_size)
    PDF::Core::PageGeometry::SIZES[page_size]
  end
end