require 'prawn'

class PageWriter < Prawn::Document
  def write(text, options)
    validate_options(options)
    position_key = get_position_key(options)
    width_option = options[:width]
    text_width = width_of(text)
    wrap_width = calculate_wrap_width(options, position_key)
    if width_option
      options[:align] = position_key
      convert_position_key(options, width_option, position_key)
    elsif text_width < wrap_width or options[:single_line]
      convert_position_key(options, text_width, position_key)
    else
      options[:width] = calculate_item_width(position_key, wrap_width)
      options[:align] = position_key
      convert_position_key(options, options[:width], position_key)
    end
    text_box(text, options)
  end

  def validate_options(options)

  end

  def get_position_key(options)
    option_keys = options.keys
    [:left, :right, :center].each do |position_key|
      return position_key if option_keys.include? position_key
    end
  end

  def calculate_wrap_width(options, position_key)
    page_width = PDF::Core::PageGeometry::SIZES['A4'][0]
    left_amount = options[position_key][0]
    right_amount = page_width - left_amount
    {:left => right_amount, :center => [left_amount, right_amount].min, :right => left_amount}[position_key]
  end

  def calculate_item_width(position_key, wrap_width)
    return wrap_width*2 if position_key == :center
    wrap_width
  end

  def convert_position_key(options, width, position_key)
    shift_amount = {:left => 0, :center => width/2, :right => width}[position_key]
    position = options.delete(position_key)
    position[0] -= shift_amount
    options[:at] = position
  end
end