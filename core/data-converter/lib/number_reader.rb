class NumberReader
  @@zero_reading = 'sıfır'
  @@digit_readings = ['', 'bir', 'iki', 'üç', 'dört', 'beş', 'altı', 'yedi', 'sekiz', 'dokuz']
  @@tens_readings = ['', 'on', 'yirmi', 'otuz', 'kırk', 'elli', 'altmış', 'yetmiş', 'seksen', 'doksan']
  @@hundreds_readings = ['', 'yüz', 'iki yüz', 'üç yüz', 'dört yüz', 'beş yüz',
  'altı yüz', 'yedi yüz', 'sekiz yüz', 'dokuz yüz']
  @@higher_order_readings = ['', 'bin', 'milyon', 'milyar', 'trilyon', 'katrilyon', 'kentilyon']

  def read(number)
    raise TypeError unless number.is_a? Integer
    return @@zero_reading if number == 0
    return 'bilinmeyen sayı' if number.abs >= 1000000000000000000000
    result = read_positive_number number.abs
    result = 'eksi ' + result if number < 0
    result
  end

  private
  def read_positive_number(number)
    number_parts = get_number_parts number
    result = ''
    for i in 0..(number_parts.length-1)
      number_part_value = number_parts[i].to_i
      order_reading = (number_part_value == 0)? '' : @@higher_order_readings[i]
      number_part_reading = (i == 1 and number_part_value == 1)? '' : read_number_part(number_parts[i])
      result = number_part_reading + ' ' + order_reading + ' ' + result
    end
    result.strip.gsub(/\s+/, ' ')
  end

  def read_number_part(number_part)
    digits = number_part.chars.map(&:to_i)
    @@hundreds_readings[digits[0]] + ' ' + @@tens_readings[digits[1]] + ' ' + @@digit_readings[digits[2]]
  end

  def get_number_parts(number)
    number_str = number.to_s
    number_str.rjust(((number_str.length + 2) / 3) * 3, '0').scan(/.{3}/).reverse
  end
end