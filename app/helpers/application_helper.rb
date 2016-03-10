require 'turkish_support'
require_relative "#{Rails.root}/core/number-reader/number_reader"

module ApplicationHelper
  using TurkishSupport
  @@number_reader = NumberReader.new

  def get_price_reading(price)
    integer_part = price.to_i
    fraction_part = (price.modulo(1).round(2) * 100).to_i
    result = (@@number_reader.read(integer_part).upcase + " TL")
    if (fraction_part != 0)
      result += (" " + @@number_reader.read(fraction_part).upcase + " KURUŞ")
    end
    return (result + ".")
  end

  def format_price(price)
    return sprintf('%.2f', price)
  end
end
