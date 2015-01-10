require_relative 'number_reader'

def get_input
  print 'Sayı: '
  gets.chomp
end

def is_i?(str)
  /\A[-+]?\d+\z/ === str
end

reader = NumberReader.new
input = get_input
until %w(quit exit q).include? input
  if is_i? input
    number = input.to_i
    puts 'Okunuş: ' + reader.read(number)
  else
    puts 'Geçersiz sayı.'
  end
  input = get_input
end
