require 'prawn'

class PageWriter < Prawn::Document
  def write(text, options)
    position_key = get_position_key(options.keys)
    width = get_item_width(text, options)
    shift_amount = {:left => 0, :center => width/2, :right => width}[position_key]
    position = options.delete(position_key)
    position[0] -= shift_amount
    options[:at] = position
    options[:align] = position_key if options[:width] or options[:height]
    text_box(text, options)
  end

  # TODO: dogrulama. get_type. type'a göre align konulacak.

  def get_position_key(option_keys)
    [:left, :center, :right].each do |position_key|
      return position_key if option_keys.include? position_key
    end
  end

  def get_item_width(text, options)
    return options[:width] if options[:width]
    # TODO: height varsa sayfa sonuna kadarki kismin iki kati donulecek.
    width_of(text)
  end
end