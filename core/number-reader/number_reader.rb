class NumberReader
  @@digit_readings = [''] + %w(bir iki üç dört beş altı yedi sekiz dokuz)
  @@tens_readings = [''] + %w(on yirmi otuz kırk elli altmış yetmiş seksen doksan)
  @@higher_order_readings = [''] + %w(bin milyon milyar trilyon katrilyon kentilyon)

  def read(number)
    raise TypeError unless number.is_a? Integer
    return 'sıfır' if number == 0
    return 'bilinmiyor' if number.abs >= 1000000000000000000000
    result = read_positive_number number.abs
    result = 'eksi ' + result if number < 0
    result
  end

  private
  def read_positive_number(number)
    number_parts = get_number_parts number
    result = ''
    number_parts.each_with_index do |number_part, i|
      result = read_number_part_with_order(number_part, i) + ' ' + result
    end
    result.strip.gsub(/\s+/, ' ')
  end

  def get_number_parts(number)
    number_str = number.to_s
    number_str.rjust(((number_str.length+2)/3)*3, '0').scan(/.{3}/).reverse
  end

  def read_number_part_with_order(number_part, order)
    number = number_part.to_i
    return '' if number == 0
    return 'bin' if number == 1 and order == 1
    read_number_part(number_part) + ' ' + @@higher_order_readings[order]
  end

  def read_number_part(number_part)
    digits = number_part.chars.map(&:to_i)
    get_hundred_reading(digits[0]) + ' ' + @@tens_readings[digits[1]] + ' ' + @@digit_readings[digits[2]]
  end

  def get_hundred_reading(digit)
    return '' if digit == 0
    ((digit == 1)? '' : @@digit_readings[digit]) + ' yüz'
  end
end
