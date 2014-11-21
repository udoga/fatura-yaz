require 'minitest/autorun'
require_relative '../lib/invoice_config'

class TestPageConfig < MiniTest::Test
  def setup
    @config = InvoiceConfig.from_file('config/valid.yml')
  end

  def test_gets_yaml_parameters
    assert_equal 'A4', @config.page_size
    assert_equal 12, @config.font_size
  end

  def test_has_default_values
    assert_equal '../fonts/Arial.ttf', @config.font
    assert_equal 0, @config.default_leading
  end

  def test_page_items
    assert_equal({:at => [429, 619]}, @config.page_item('date'))
    assert_equal 230, @config.page_item('buyer-address')[:width]
    assert_equal :right, @config.page_item('general_total')[:align]
    assert_equal [80, 491], @config.page_item('line_items.description')[:at]
  end

  def test_absent_page_items
    assert_equal nil, @config.page_item('time')
    assert_equal nil, @config.page_item('line_items.id')
    assert_equal nil, @config.page_item('line_items.id.something')
  end

  def test_addenda
    assert_equal 9, @config.addenda('some content')[:size]
    assert_equal ['some content'], @config.get_addenda_contents
  end
end