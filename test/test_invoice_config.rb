require 'minitest/autorun'
require_relative '../lib/invoice_config'

class TestPageConfig < MiniTest::Test
  def setup
    @valid_config = InvoiceConfig.from_file('config/valid.yml')
    @empty_config = InvoiceConfig.from_file('config/empty.yml')
  end

  def test_gets_yaml_parameters
    assert_equal 'A4', @valid_config.page_size
    assert_equal 12, @valid_config.font_size
  end

  def test_has_default_values
    assert_equal '../fonts/Arial.ttf', @valid_config.font
    assert_equal 0, @valid_config.default_leading
  end

  def test_page_items
    assert_equal({:left => [429, 619]}, @valid_config.page_item('date'))
    assert_equal 230, @valid_config.page_item('buyer-address')[:width]
    assert_equal [317, 499], @valid_config.page_item('line_items.quantity')[:center]
  end

  def test_absent_page_items
    assert_equal nil, @empty_config.page_item('date')
    assert_equal nil, @empty_config.page_item('line_items.id')
    assert_equal nil, @empty_config.page_item('line_items.id.something')
  end

  def test_addenda
    assert_equal 9, @valid_config.addenda('some content')[:size]
    assert_equal ['some content'], @valid_config.get_addenda_contents
  end

  def test_empty_addenda
    assert_equal [], @empty_config.get_addenda_contents
    assert_equal nil, @empty_config.addenda('some content')
  end
end