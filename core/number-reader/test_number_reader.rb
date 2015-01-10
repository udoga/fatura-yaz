require 'minitest/autorun'
require_relative 'number_reader'

class TestNumberReader < MiniTest::Test
  def setup
    @reader = NumberReader.new
  end

  def test_zero
    assert_equal 'sıfır', @reader.read(0)
  end

  def test_one_digit_numbers
    assert_equal 'bir', @reader.read(1)
    assert_equal 'iki', @reader.read(2)
    assert_equal 'dokuz', @reader.read(9)
  end

  def test_two_digit_numbers
    assert_equal 'on', @reader.read(10)
    assert_equal 'yirmi', @reader.read(20)
    assert_equal 'yirmi bir', @reader.read(21)
    assert_equal 'doksan dokuz', @reader.read(99)
  end

  def test_three_digit_numbers
    assert_equal 'yüz', @reader.read(100)
    assert_equal 'iki yüz', @reader.read(200)
    assert_equal 'yüz yirmi üç', @reader.read(123)
    assert_equal 'yüz bir', @reader.read(101)
    assert_equal 'iki yüz iki', @reader.read(202)
    assert_equal 'üç yüz otuz', @reader.read(330)
  end

  def test_four_digit_numbers
    assert_equal 'bin', @reader.read(1000)
    assert_equal 'iki bin', @reader.read(2000)
    assert_equal 'iki bin beş', @reader.read(2005)
    assert_equal 'bin yüz', @reader.read(1100)
    assert_equal 'dört bin doksan altı', @reader.read(4096)
    assert_equal 'sekiz bin yüz doksan iki', @reader.read(8192)
  end

  def test_big_numbers
    assert_equal 'bir milyon', @reader.read(1000000)
    assert_equal 'bir milyar bir milyon bin', @reader.read(1001001000)
    assert_equal 'otuz sekiz milyon dört yüz yirmi bin kırk dokuz', @reader.read(38420049)
  end

  def test_other_inputs
    assert_raises(TypeError) { @reader.read('5') }
    assert_equal 'eksi bir', @reader.read(-1)
    assert_equal 'bilinmiyor', @reader.read(1000000000000000000000)
    assert_equal 'bilinmiyor', @reader.read(-1000000000000000000000000)
  end
end
